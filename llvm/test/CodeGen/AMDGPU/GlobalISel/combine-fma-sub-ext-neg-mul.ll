; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx900 --denormal-fp-math=preserve-sign < %s | FileCheck -check-prefix=GFX9-DENORM %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1010 --denormal-fp-math=preserve-sign < %s | FileCheck -check-prefix=GFX10-DENORM %s

; fold (fsub (fpext (fneg (fmul, x, y))), z) -> (fneg (fma (fpext x), (fpext y), z))
define amdgpu_vs float @test_f16_to_f32_sub_ext_neg_mul(half %x, half %y, float %z) {
; GFX9-DENORM-LABEL: test_f16_to_f32_sub_ext_neg_mul:
; GFX9-DENORM:       ; %bb.0: ; %entry
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e64 v1, -v1
; GFX9-DENORM-NEXT:    v_mad_f32 v0, v0, v1, -v2
; GFX9-DENORM-NEXT:    ; return to shader part epilog
;
; GFX10-DENORM-LABEL: test_f16_to_f32_sub_ext_neg_mul:
; GFX10-DENORM:       ; %bb.0: ; %entry
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e64 v1, -v1
; GFX10-DENORM-NEXT:    v_fma_f32 v0, v0, v1, -v2
; GFX10-DENORM-NEXT:    ; return to shader part epilog
entry:
  %a = fmul fast half %x, %y
  %b = fneg half %a
  %c = fpext half %b to float
  %d = fsub fast float %c, %z
  ret float %d
}

; fold (fsub (fneg (fpext (fmul, x, y))), z) -> (fneg (fma (fpext x)), (fpext y), z)
define amdgpu_vs float @test_f16_to_f32_sub_neg_ext_mul(half %x, half %y, float %z) {
; GFX9-DENORM-LABEL: test_f16_to_f32_sub_neg_ext_mul:
; GFX9-DENORM:       ; %bb.0: ; %entry
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e64 v1, -v1
; GFX9-DENORM-NEXT:    v_mad_f32 v0, v0, v1, -v2
; GFX9-DENORM-NEXT:    ; return to shader part epilog
;
; GFX10-DENORM-LABEL: test_f16_to_f32_sub_neg_ext_mul:
; GFX10-DENORM:       ; %bb.0: ; %entry
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e64 v1, -v1
; GFX10-DENORM-NEXT:    v_fma_f32 v0, v0, v1, -v2
; GFX10-DENORM-NEXT:    ; return to shader part epilog
entry:
  %a = fmul fast half %x, %y
  %b = fpext half %a to float
  %c = fneg float %b
  %d = fsub fast float %c, %z
  ret float %d
}


; fold (fsub x, (fpext (fneg (fmul y, z)))) -> (fma (fpext y), (fpext z), x)
define amdgpu_vs float @test_f16_to_f32_sub_ext_neg_mul2(float %x, half %y, half %z) {
; GFX9-DENORM-LABEL: test_f16_to_f32_sub_ext_neg_mul2:
; GFX9-DENORM:       ; %bb.0: ; %entry
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v1, v1
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e64 v2, -v2
; GFX9-DENORM-NEXT:    v_mad_f32 v0, -v1, v2, v0
; GFX9-DENORM-NEXT:    ; return to shader part epilog
;
; GFX10-DENORM-LABEL: test_f16_to_f32_sub_ext_neg_mul2:
; GFX10-DENORM:       ; %bb.0: ; %entry
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v1, v1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e64 v2, -v2
; GFX10-DENORM-NEXT:    v_fma_f32 v0, -v1, v2, v0
; GFX10-DENORM-NEXT:    ; return to shader part epilog
entry:
  %a = fmul fast half %y, %z
  %b = fneg half %a
  %c = fpext half %b to float
  %d = fsub fast float %x, %c
  ret float %d
}

; fold (fsub x, (fneg (fpext (fmul y, z)))) -> (fma (fpext y), (fpext z), x)
define amdgpu_vs float @test_f16_to_f32_sub_neg_ext_mul2(float %x, half %y, half %z) {
; GFX9-DENORM-LABEL: test_f16_to_f32_sub_neg_ext_mul2:
; GFX9-DENORM:       ; %bb.0: ; %entry
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v1, v1
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e64 v2, -v2
; GFX9-DENORM-NEXT:    v_mad_f32 v0, -v1, v2, v0
; GFX9-DENORM-NEXT:    ; return to shader part epilog
;
; GFX10-DENORM-LABEL: test_f16_to_f32_sub_neg_ext_mul2:
; GFX10-DENORM:       ; %bb.0: ; %entry
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v1, v1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e64 v2, -v2
; GFX10-DENORM-NEXT:    v_fma_f32 v0, -v1, v2, v0
; GFX10-DENORM-NEXT:    ; return to shader part epilog
entry:
  %a = fmul fast half %y, %z
  %b = fpext half %a to float
  %c = fneg float %b
  %d = fsub fast float %x, %c
  ret float %d
}

; fold (fsub (fpext (fneg (fmul, x, y))), z) -> (fneg (fma (fpext x), (fpext y), z))
define amdgpu_vs <4 x float> @test_v4f16_to_v4f32_sub_ext_neg_mul(<4 x half> %x, <4 x half> %y, <4 x float> %z) {
; GFX9-DENORM-LABEL: test_v4f16_to_v4f32_sub_ext_neg_mul:
; GFX9-DENORM:       ; %bb.0: ; %entry
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v0, v0, v2 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v1, v1, v3 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v2, v0
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_sdwa v3, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v8, v1
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_sdwa v9, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v0, v2, v4
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v1, v3, v5
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v2, v8, v6
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v3, v9, v7
; GFX9-DENORM-NEXT:    ; return to shader part epilog
;
; GFX10-DENORM-LABEL: test_v4f16_to_v4f32_sub_ext_neg_mul:
; GFX10-DENORM:       ; %bb.0: ; %entry
; GFX10-DENORM-NEXT:    s_mov_b32 s0, 0x80008000
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v8, v0
; GFX10-DENORM-NEXT:    v_xor_b32_e32 v2, s0, v2
; GFX10-DENORM-NEXT:    v_xor_b32_e32 v3, s0, v3
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v9, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v10, v1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v11, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v0, v2
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v1, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v2, v3
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v3, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_fma_f32 v0, v8, v0, -v4
; GFX10-DENORM-NEXT:    v_fma_f32 v1, v9, v1, -v5
; GFX10-DENORM-NEXT:    v_fma_f32 v2, v10, v2, -v6
; GFX10-DENORM-NEXT:    v_fma_f32 v3, v11, v3, -v7
; GFX10-DENORM-NEXT:    ; return to shader part epilog
entry:
  %a = fmul fast <4 x half> %x, %y
  %b = fneg <4 x half> %a
  %c = fpext <4 x half> %b to <4 x float>
  %d = fsub fast <4 x float> %c, %z
  ret <4 x float> %d
}

; fold (fsub (fneg (fpext (fmul, x, y))), z) -> (fneg (fma (fpext x)), (fpext y), z)
define amdgpu_vs <4 x float> @test_v4f16_to_v4f32_sub_neg_ext_mul(<4 x half> %x, <4 x half> %y, <4 x float> %z) {
; GFX9-DENORM-LABEL: test_v4f16_to_v4f32_sub_neg_ext_mul:
; GFX9-DENORM:       ; %bb.0: ; %entry
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v0, v0, v2 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v1, v1, v3 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v2, v0
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_sdwa v3, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v8, v1
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_sdwa v9, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v0, v2, v4
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v1, v3, v5
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v2, v8, v6
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v3, v9, v7
; GFX9-DENORM-NEXT:    ; return to shader part epilog
;
; GFX10-DENORM-LABEL: test_v4f16_to_v4f32_sub_neg_ext_mul:
; GFX10-DENORM:       ; %bb.0: ; %entry
; GFX10-DENORM-NEXT:    s_mov_b32 s0, 0x80008000
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v8, v0
; GFX10-DENORM-NEXT:    v_xor_b32_e32 v2, s0, v2
; GFX10-DENORM-NEXT:    v_xor_b32_e32 v3, s0, v3
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v9, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v10, v1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v11, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v0, v2
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v1, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v2, v3
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v3, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_fma_f32 v0, v8, v0, -v4
; GFX10-DENORM-NEXT:    v_fma_f32 v1, v9, v1, -v5
; GFX10-DENORM-NEXT:    v_fma_f32 v2, v10, v2, -v6
; GFX10-DENORM-NEXT:    v_fma_f32 v3, v11, v3, -v7
; GFX10-DENORM-NEXT:    ; return to shader part epilog
entry:
  %a = fmul fast <4 x half> %x, %y
  %b = fpext <4 x half> %a to <4 x float>
  %c = fneg <4 x float> %b
  %d = fsub fast <4 x float> %c, %z
  ret <4 x float> %d
}


; fold (fsub x, (fpext (fneg (fmul y, z)))) -> (fma (fpext y), (fpext z), x)
define amdgpu_vs <4 x float> @test_v4f16_to_v4f32_sub_ext_neg_mul2(<4 x float> %x, <4 x half> %y, <4 x half> %z) {
; GFX9-DENORM-LABEL: test_v4f16_to_v4f32_sub_ext_neg_mul2:
; GFX9-DENORM:       ; %bb.0: ; %entry
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v4, v4, v6 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v5, v5, v7 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v6, v4
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_sdwa v4, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v7, v5
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_sdwa v5, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v0, v0, v6
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v1, v1, v4
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v2, v2, v7
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v3, v3, v5
; GFX9-DENORM-NEXT:    ; return to shader part epilog
;
; GFX10-DENORM-LABEL: test_v4f16_to_v4f32_sub_ext_neg_mul2:
; GFX10-DENORM:       ; %bb.0: ; %entry
; GFX10-DENORM-NEXT:    s_mov_b32 s0, 0x80008000
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v8, v4
; GFX10-DENORM-NEXT:    v_xor_b32_e32 v6, s0, v6
; GFX10-DENORM-NEXT:    v_xor_b32_e32 v7, s0, v7
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v4, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v9, v5
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v5, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v10, v6
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v6, v6 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v11, v7
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v7, v7 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_fma_f32 v0, -v8, v10, v0
; GFX10-DENORM-NEXT:    v_fma_f32 v1, -v4, v6, v1
; GFX10-DENORM-NEXT:    v_fma_f32 v2, -v9, v11, v2
; GFX10-DENORM-NEXT:    v_fma_f32 v3, -v5, v7, v3
; GFX10-DENORM-NEXT:    ; return to shader part epilog
entry:
  %a = fmul fast <4 x half> %y, %z
  %b = fneg <4 x half> %a
  %c = fpext <4 x half> %b to <4 x float>
  %d = fsub fast <4 x float> %x, %c
  ret <4 x float> %d
}

; fold (fsub x, (fneg (fpext (fmul y, z)))) -> (fma (fpext y), (fpext z), x)
define amdgpu_vs <4 x float> @test_v4f16_to_v4f32_sub_neg_ext_mul2(<4 x float> %x, <4 x half> %y, <4 x half> %z) {
; GFX9-DENORM-LABEL: test_v4f16_to_v4f32_sub_neg_ext_mul2:
; GFX9-DENORM:       ; %bb.0: ; %entry
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v4, v4, v6 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v5, v5, v7 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v6, v4
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_sdwa v4, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v7, v5
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_sdwa v5, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v0, v0, v6
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v1, v1, v4
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v2, v2, v7
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v3, v3, v5
; GFX9-DENORM-NEXT:    ; return to shader part epilog
;
; GFX10-DENORM-LABEL: test_v4f16_to_v4f32_sub_neg_ext_mul2:
; GFX10-DENORM:       ; %bb.0: ; %entry
; GFX10-DENORM-NEXT:    s_mov_b32 s0, 0x80008000
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v8, v4
; GFX10-DENORM-NEXT:    v_xor_b32_e32 v6, s0, v6
; GFX10-DENORM-NEXT:    v_xor_b32_e32 v7, s0, v7
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v4, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v9, v5
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v5, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v10, v6
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v6, v6 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_e32 v11, v7
; GFX10-DENORM-NEXT:    v_cvt_f32_f16_sdwa v7, v7 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX10-DENORM-NEXT:    v_fma_f32 v0, -v8, v10, v0
; GFX10-DENORM-NEXT:    v_fma_f32 v1, -v4, v6, v1
; GFX10-DENORM-NEXT:    v_fma_f32 v2, -v9, v11, v2
; GFX10-DENORM-NEXT:    v_fma_f32 v3, -v5, v7, v3
; GFX10-DENORM-NEXT:    ; return to shader part epilog
entry:
  %a = fmul fast <4 x half> %y, %z
  %b = fpext <4 x half> %a to <4 x float>
  %c = fneg <4 x float> %b
  %d = fsub fast <4 x float> %x, %c
  ret <4 x float> %d
}
