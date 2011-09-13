//===-- SourceManager.cpp ---------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "lldb/Core/SourceManager.h"

// C Includes
// C++ Includes
// Other libraries and framework includes
// Project includes
#include "lldb/Core/DataBuffer.h"
#include "lldb/Core/Debugger.h"
#include "lldb/Core/Stream.h"
#include "lldb/Symbol/SymbolContext.h"
#include "lldb/Target/Target.h"

using namespace lldb_private;

static inline bool is_newline_char(char ch)
{
    return ch == '\n' || ch == '\r';
}


//----------------------------------------------------------------------
// SourceManager constructor
//----------------------------------------------------------------------
SourceManager::SourceManager(Target &target) :
    m_last_file_sp (),
    m_last_file_line (0),
    m_last_file_context_before (0),
    m_last_file_context_after (10),
    m_target (&target),
    m_debugger(NULL)
{
    m_debugger = &(m_target->GetDebugger());
}

SourceManager::SourceManager(Debugger &debugger) :
    m_last_file_sp (),
    m_last_file_line (0),
    m_last_file_context_before (0),
    m_last_file_context_after (10),
    m_target (NULL),
    m_debugger (&debugger)
{
}

//----------------------------------------------------------------------
// Destructor
//----------------------------------------------------------------------
SourceManager::~SourceManager()
{
}

size_t
SourceManager::DisplaySourceLines
(
    const FileSpec &file_spec,
    uint32_t line,
    uint32_t context_before,
    uint32_t context_after,
    Stream *s
)
{
    m_last_file_sp = GetFile (file_spec);
    m_last_file_line = line + context_after + 1;
    m_last_file_context_before = context_before;
    m_last_file_context_after = context_after;
    if (m_last_file_sp.get())
        return m_last_file_sp->DisplaySourceLines (line, context_before, context_after, s);

    return 0;
}

SourceManager::FileSP
SourceManager::GetFile (const FileSpec &file_spec)
{
    FileSP file_sp;
    file_sp = m_debugger->GetSourceFileCache().FindSourceFile (file_spec);
    if (!file_sp)
    {
        file_sp.reset (new File (file_spec, m_target));

        m_debugger->GetSourceFileCache().AddSourceFile(file_sp);
    }
    return file_sp;
}

size_t
SourceManager::DisplaySourceLinesWithLineNumbersUsingLastFile
(
    uint32_t line,
    uint32_t context_before,
    uint32_t context_after,
    const char* current_line_cstr,
    Stream *s,
    const SymbolContextList *bp_locs
)
{
    size_t return_value = 0;
    if (line == 0)
    {
        if (m_last_file_line != 0
            && m_last_file_line != UINT32_MAX)
            line = m_last_file_line + context_before;
        else
            line = 1;
    }

    m_last_file_line = line + context_after + 1;
    m_last_file_context_before = context_before;
    m_last_file_context_after = context_after;

    if (context_before == UINT32_MAX)
        context_before = 0;
    if (context_after == UINT32_MAX)
        context_after = 10;

    if (m_last_file_sp.get())
    {
        const uint32_t start_line = line <= context_before ? 1 : line - context_before;
        const uint32_t end_line = line + context_after;
        uint32_t curr_line;
        for (curr_line = start_line; curr_line <= end_line; ++curr_line)
        {
            if (!m_last_file_sp->LineIsValid (curr_line))
            {
                m_last_file_line = UINT32_MAX;
                break;
            }

            char prefix[32] = "";
            if (bp_locs)
            {
                uint32_t bp_count = bp_locs->NumLineEntriesWithLine (curr_line);
                
                if (bp_count > 0)
                    ::snprintf (prefix, sizeof (prefix), "[%u] ", bp_count);
                else
                    ::snprintf (prefix, sizeof (prefix), "    ");
            }

            return_value += s->Printf("%s%2.2s %-4u\t", 
                      prefix,
                      curr_line == line ? current_line_cstr : "", 
                      curr_line);
            size_t this_line_size = m_last_file_sp->DisplaySourceLines (curr_line, 0, 0, s); 
            if (this_line_size == 0)
            {
                m_last_file_line = UINT32_MAX;
                break;
            }
            else
                return_value += this_line_size;
        }
    }
    return return_value;
}

size_t
SourceManager::DisplaySourceLinesWithLineNumbers
(
    const FileSpec &file_spec,
    uint32_t line,
    uint32_t context_before,
    uint32_t context_after,
    const char* current_line_cstr,
    Stream *s,
    const SymbolContextList *bp_locs
)
{
    bool same_as_previous = m_last_file_sp && m_last_file_sp->FileSpecMatches (file_spec);

    if (!same_as_previous)
        m_last_file_sp = GetFile (file_spec);

    if (line == 0)
    {
        if (!same_as_previous)
            m_last_file_line = 0;
    }

    return DisplaySourceLinesWithLineNumbersUsingLastFile (line, context_before, context_after, current_line_cstr, s, bp_locs);
}

size_t
SourceManager::DisplayMoreWithLineNumbers (Stream *s, const SymbolContextList *bp_locs)
{
    if (m_last_file_sp)
    {
        if (m_last_file_line == UINT32_MAX)
            return 0;
        return DisplaySourceLinesWithLineNumbersUsingLastFile (0, m_last_file_context_before, m_last_file_context_after, "", s, bp_locs);
    }
    return 0;
}

bool
SourceManager::SetDefaultFileAndLine (const FileSpec &file_spec, uint32_t line)
{
    FileSP old_file_sp = m_last_file_sp;
    m_last_file_sp = GetFile (file_spec);
    if (m_last_file_sp)
    {
        m_last_file_line = line;
        return true;
    }
    else
    {
        m_last_file_sp = old_file_sp;
        return false;
    }
}

bool 
SourceManager::GetDefaultFileAndLine (FileSpec &file_spec, uint32_t &line)
{
    if (m_last_file_sp)
    {
        file_spec = m_last_file_sp->GetFileSpec();
        line = m_last_file_line;
        return true;
    }
    else
        return false;
}


SourceManager::File::File(const FileSpec &file_spec, Target *target) :
    m_file_spec_orig (file_spec),
    m_file_spec(file_spec),
    m_mod_time (file_spec.GetModificationTime()),
    m_data_sp(),
    m_offsets()
{
    if (!m_mod_time.IsValid())
    {
        if (target)
        {
            if (!file_spec.GetDirectory() && file_spec.GetFilename())
            {
                // If this is just a file name, lets see if we can find it in the target:
                bool check_inlines = false;
                SymbolContextList sc_list;
                size_t num_matches = target->GetImages().ResolveSymbolContextForFilePath (file_spec.GetFilename().AsCString(),
                                                                                          0,
                                                                                          check_inlines,
                                                                                          lldb::eSymbolContextModule | lldb::eSymbolContextCompUnit,
                                                                                          sc_list);
                bool got_multiple = false;
                if (num_matches != 0)
                {
                    if (num_matches > 1)
                    {
                        SymbolContext sc;
                        FileSpec *test_cu_spec = NULL;

                        for (unsigned i = 0; i < num_matches; i++)
                        {
                            sc_list.GetContextAtIndex(i, sc);
                            if (sc.comp_unit)
                            {
                                if (test_cu_spec)
                                {
                                    if (test_cu_spec != static_cast<FileSpec *> (sc.comp_unit))
                                        got_multiple = true;
                                        break;
                                }
                                else
                                    test_cu_spec = sc.comp_unit;
                            }
                        }
                    }
                    if (!got_multiple)
                    {
                        SymbolContext sc;
                        sc_list.GetContextAtIndex (0, sc);
                        m_file_spec = static_cast<FileSpec *>(sc.comp_unit);
                        m_mod_time = m_file_spec.GetModificationTime();
                    }
                }
            }
            else
            {
                if (target->GetSourcePathMap().RemapPath(file_spec.GetDirectory(), m_file_spec.GetDirectory()))
                   m_mod_time = file_spec.GetModificationTime();
            }
        }
    }
    
    if (m_mod_time.IsValid())
        m_data_sp = m_file_spec.ReadFileContents ();
}

SourceManager::File::~File()
{
}

uint32_t
SourceManager::File::GetLineOffset (uint32_t line)
{
    if (line == 0)
        return UINT32_MAX;

    if (line == 1)
        return 0;

    if (CalculateLineOffsets (line))
    {
        if (line < m_offsets.size())
            return m_offsets[line - 1]; // yes we want "line - 1" in the index
    }
    return UINT32_MAX;
}

bool
SourceManager::File::LineIsValid (uint32_t line)
{
    if (line == 0)
        return false;

    if (CalculateLineOffsets (line))
        return line < m_offsets.size();
    return false;
}

size_t
SourceManager::File::DisplaySourceLines (uint32_t line, uint32_t context_before, uint32_t context_after, Stream *s)
{
    // TODO: use host API to sign up for file modifications to anything in our
    // source cache and only update when we determine a file has been updated.
    // For now we check each time we want to display info for the file.
    TimeValue curr_mod_time (m_file_spec.GetModificationTime());
    if (m_mod_time != curr_mod_time)
    {
        m_mod_time = curr_mod_time;
        m_data_sp = m_file_spec.ReadFileContents ();
        m_offsets.clear();
    }

    const uint32_t start_line = line <= context_before ? 1 : line - context_before;
    const uint32_t start_line_offset = GetLineOffset (start_line);
    if (start_line_offset != UINT32_MAX)
    {
        const uint32_t end_line = line + context_after;
        uint32_t end_line_offset = GetLineOffset (end_line + 1);
        if (end_line_offset == UINT32_MAX)
            end_line_offset = m_data_sp->GetByteSize();

        assert (start_line_offset <= end_line_offset);
        size_t bytes_written = 0;
        if (start_line_offset < end_line_offset)
        {
            size_t count = end_line_offset - start_line_offset;
            const uint8_t *cstr = m_data_sp->GetBytes() + start_line_offset;
            bytes_written = s->Write(cstr, count);
            if (!is_newline_char(cstr[count-1]))
                bytes_written += s->EOL();
        }
        return bytes_written;
    }
    return 0;
}

bool
SourceManager::File::FileSpecMatches (const FileSpec &file_spec)
{
    return FileSpec::Equal (m_file_spec, file_spec, false);
}

bool
lldb_private::operator== (const SourceManager::File &lhs, const SourceManager::File &rhs)
{
    if (lhs.m_file_spec == rhs.m_file_spec)
    {
        if (lhs.m_mod_time.IsValid())
        {
            if (rhs.m_mod_time.IsValid())
                return lhs.m_mod_time == rhs.m_mod_time;
            else
                return false;
        }
        else if (rhs.m_mod_time.IsValid())
            return false;
        else
            return true;
    }
    else
        return false;
}

bool
SourceManager::File::CalculateLineOffsets (uint32_t line)
{
    line = UINT32_MAX;  // TODO: take this line out when we support partial indexing
    if (line == UINT32_MAX)
    {
        // Already done?
        if (!m_offsets.empty() && m_offsets[0] == UINT32_MAX)
            return true;

        if (m_offsets.empty())
        {
            if (m_data_sp.get() == NULL)
                return false;

            const char *start = (char *)m_data_sp->GetBytes();
            if (start)
            {
                const char *end = start + m_data_sp->GetByteSize();

                // Calculate all line offsets from scratch

                // Push a 1 at index zero to indicate the file has been completely indexed.
                m_offsets.push_back(UINT32_MAX);
                register const char *s;
                for (s = start; s < end; ++s)
                {
                    register char curr_ch = *s;
                    if (is_newline_char (curr_ch))
                    {
                        register char next_ch = s[1];
                        if (is_newline_char (next_ch))
                        {
                            if (curr_ch != next_ch)
                                ++s;
                        }
                        m_offsets.push_back(s + 1 - start);
                    }
                }
                if (!m_offsets.empty())
                {
                    if (m_offsets.back() < end - start)
                        m_offsets.push_back(end - start);
                }
                return true;
            }
        }
        else
        {
            // Some lines have been populated, start where we last left off
            assert(!"Not implemented yet");
        }

    }
    else
    {
        // Calculate all line offsets up to "line"
        assert(!"Not implemented yet");
    }
    return false;
}

void 
SourceManager::SourceFileCache::AddSourceFile (const FileSP &file_sp)
{
    FileSpec file_spec;
    FileCache::iterator pos = m_file_cache.find(file_spec);
    if (pos == m_file_cache.end())
        m_file_cache[file_spec] = file_sp;
    else
    {
        if (file_sp != pos->second)
            m_file_cache[file_spec] = file_sp;
    }
}

SourceManager::FileSP 
SourceManager::SourceFileCache::FindSourceFile (const FileSpec &file_spec) const
{
    FileSP file_sp;
    FileCache::const_iterator pos = m_file_cache.find(file_spec);
    if (pos != m_file_cache.end())
        file_sp = pos->second;
    return file_sp;
}

