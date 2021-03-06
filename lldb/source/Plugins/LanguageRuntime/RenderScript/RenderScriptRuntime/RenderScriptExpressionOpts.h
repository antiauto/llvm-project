//===-- RenderScriptExpressionOpts.h ----------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_SOURCE_PLUGINS_LANGUAGERUNTIME_RENDERSCRIPT_RENDERSCRIPTRUNTIME_RENDERSCRIPTEXPRESSIONOPTS_H
#define LLDB_SOURCE_PLUGINS_LANGUAGERUNTIME_RENDERSCRIPT_RENDERSCRIPTRUNTIME_RENDERSCRIPTEXPRESSIONOPTS_H

#include "llvm/IR/Module.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Pass.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"

#include "lldb/Target/LanguageRuntime.h"
#include "lldb/Target/Process.h"
#include "lldb/lldb-private.h"

#include "RenderScriptRuntime.h"
#include "RenderScriptx86ABIFixups.h"

// RenderScriptRuntimeModulePass is a simple llvm::ModulesPass that is used
// during expression evaluation to apply RenderScript-specific fixes for
// expression evaluation. In particular this is used to make expression IR
// conformant with the ABI generated by the slang frontend. This ModulePass is
// executed in ClangExpressionParser::PrepareForExecution whenever an
// expression's DWARF language is eLanguageTypeExtRenderscript

class RenderScriptRuntimeModulePass : public llvm::ModulePass {
public:
  static char ID;
  RenderScriptRuntimeModulePass(const lldb_private::Process *process)
      : ModulePass(ID), m_process_ptr(process) {}

  bool runOnModule(llvm::Module &module) override;

private:
  const lldb_private::Process *m_process_ptr;
};

namespace lldb_private {
namespace lldb_renderscript {
struct RSIRPasses : public lldb_private::LLVMUserExpression::IRPasses {
  RSIRPasses(lldb_private::Process *process);

  ~RSIRPasses();
};
} // namespace lldb_renderscript
} // namespace lldb_private
#endif
