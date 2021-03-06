; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mattr=+simd128 | FileCheck %s

; Test that a vector trunc correctly optimizes and lowers to narrow instructions

target triple = "wasm32-unknown-unknown"

define <16 x i8>  @trunc16i64_16i8(<16 x i64> %a) {
; CHECK-LABEL: trunc16i64_16i8:
; CHECK:         .functype trunc16i64_16i8 (v128, v128, v128, v128, v128, v128, v128, v128) -> (v128)
; CHECK-NEXT:    .local v128
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    v128.const 255, 255
; CHECK-NEXT:    local.tee 8
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    local.get 8
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i16x8.narrow_i32x4_u
; CHECK-NEXT:    local.get 2
; CHECK-NEXT:    local.get 8
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    local.get 3
; CHECK-NEXT:    local.get 8
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i16x8.narrow_i32x4_u
; CHECK-NEXT:    i16x8.narrow_i32x4_u
; CHECK-NEXT:    local.get 4
; CHECK-NEXT:    local.get 8
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    local.get 5
; CHECK-NEXT:    local.get 8
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i16x8.narrow_i32x4_u
; CHECK-NEXT:    local.get 6
; CHECK-NEXT:    local.get 8
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    local.get 7
; CHECK-NEXT:    local.get 8
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i16x8.narrow_i32x4_u
; CHECK-NEXT:    i16x8.narrow_i32x4_u
; CHECK-NEXT:    i8x16.narrow_i16x8_u
; CHECK-NEXT:    # fallthrough-return
entry:
  %0 = trunc <16 x i64> %a to <16 x i8>
  ret <16 x i8> %0
}

define <16 x i8>  @trunc16i32_16i8(<16 x i32> %a) {
; CHECK-LABEL: trunc16i32_16i8:
; CHECK:         .functype trunc16i32_16i8 (v128, v128, v128, v128) -> (v128)
; CHECK-NEXT:    .local v128
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    v128.const 255, 255, 255, 255
; CHECK-NEXT:    local.tee 4
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    local.get 4
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i16x8.narrow_i32x4_u
; CHECK-NEXT:    local.get 2
; CHECK-NEXT:    local.get 4
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    local.get 3
; CHECK-NEXT:    local.get 4
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i16x8.narrow_i32x4_u
; CHECK-NEXT:    i8x16.narrow_i16x8_u
; CHECK-NEXT:    # fallthrough-return
entry:
  %0 = trunc <16 x i32> %a to <16 x i8>
  ret <16 x i8> %0
}

define <16 x i8>  @trunc16i16_16i8(<16 x i16> %a) {
; CHECK-LABEL: trunc16i16_16i8:
; CHECK:         .functype trunc16i16_16i8 (v128, v128) -> (v128)
; CHECK-NEXT:    .local v128
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    v128.const 255, 255, 255, 255, 255, 255, 255, 255
; CHECK-NEXT:    local.tee 2
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    local.get 2
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i8x16.narrow_i16x8_u
; CHECK-NEXT:    # fallthrough-return
entry:
  %0 = trunc <16 x i16> %a to <16 x i8>
  ret <16 x i8> %0
}

define <8 x i16> @trunc8i64_8i16(<8 x i64> %a) {
; CHECK-LABEL: trunc8i64_8i16:
; CHECK:         .functype trunc8i64_8i16 (v128, v128, v128, v128) -> (v128)
; CHECK-NEXT:    .local v128
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    v128.const 65535, 65535
; CHECK-NEXT:    local.tee 4
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    local.get 4
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i16x8.narrow_i32x4_u
; CHECK-NEXT:    local.get 2
; CHECK-NEXT:    local.get 4
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    local.get 3
; CHECK-NEXT:    local.get 4
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i16x8.narrow_i32x4_u
; CHECK-NEXT:    i16x8.narrow_i32x4_u
; CHECK-NEXT:    # fallthrough-return
entry:
  %0 = trunc <8 x i64> %a to <8 x i16>
  ret <8 x i16> %0
}

define <8 x i16> @trunc8i32_8i16(<8 x i32> %a) {
; CHECK-LABEL: trunc8i32_8i16:
; CHECK:         .functype trunc8i32_8i16 (v128, v128) -> (v128)
; CHECK-NEXT:    .local v128
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    v128.const 65535, 65535, 65535, 65535
; CHECK-NEXT:    local.tee 2
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    local.get 2
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i16x8.narrow_i32x4_u
; CHECK-NEXT:    # fallthrough-return
entry:
  %0 = trunc <8 x i32> %a to <8 x i16>
  ret <8 x i16> %0
}
