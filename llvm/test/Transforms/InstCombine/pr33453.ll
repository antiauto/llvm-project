; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S %s | FileCheck %s

@g1 = external global i16
@g2 = external global i16

define float @patatino() {
; CHECK-LABEL: @patatino(
; CHECK-NEXT:    ret float fmul (float uitofp (i1 icmp eq (i16* getelementptr inbounds (i16, i16* @g2, i64 1), i16* @g1) to float), float uitofp (i1 icmp eq (i16* getelementptr inbounds (i16, i16* @g2, i64 1), i16* @g1) to float))
;
  %call = call float @fabsf(float fmul (float uitofp (i1 icmp eq (i16* getelementptr inbounds (i16, i16* @g2, i64 1), i16* @g1) to float), float uitofp (i1 icmp eq (i16* getelementptr inbounds (i16, i16* @g2, i64 1), i16* @g1) to float)))
  ret float %call
}

declare float @fabsf(float)
