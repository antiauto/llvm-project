; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=lower-matrix-intrinsics -matrix-default-layout=row-major -S < %s | FileCheck --check-prefix=RM %s

define <8 x double> @transpose(<8 x double> %a) {
; RM-LABEL: @transpose(
; RM-NEXT:  entry:
; RM-NEXT:    [[SPLIT:%.*]] = shufflevector <8 x double> [[A:%.*]], <8 x double> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; RM-NEXT:    [[SPLIT1:%.*]] = shufflevector <8 x double> [[A]], <8 x double> poison, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; RM-NEXT:    [[TMP0:%.*]] = extractelement <4 x double> [[SPLIT]], i64 0
; RM-NEXT:    [[TMP1:%.*]] = insertelement <2 x double> undef, double [[TMP0]], i64 0
; RM-NEXT:    [[TMP2:%.*]] = extractelement <4 x double> [[SPLIT1]], i64 0
; RM-NEXT:    [[TMP3:%.*]] = insertelement <2 x double> [[TMP1]], double [[TMP2]], i64 1
; RM-NEXT:    [[TMP4:%.*]] = extractelement <4 x double> [[SPLIT]], i64 1
; RM-NEXT:    [[TMP5:%.*]] = insertelement <2 x double> undef, double [[TMP4]], i64 0
; RM-NEXT:    [[TMP6:%.*]] = extractelement <4 x double> [[SPLIT1]], i64 1
; RM-NEXT:    [[TMP7:%.*]] = insertelement <2 x double> [[TMP5]], double [[TMP6]], i64 1
; RM-NEXT:    [[TMP8:%.*]] = extractelement <4 x double> [[SPLIT]], i64 2
; RM-NEXT:    [[TMP9:%.*]] = insertelement <2 x double> undef, double [[TMP8]], i64 0
; RM-NEXT:    [[TMP10:%.*]] = extractelement <4 x double> [[SPLIT1]], i64 2
; RM-NEXT:    [[TMP11:%.*]] = insertelement <2 x double> [[TMP9]], double [[TMP10]], i64 1
; RM-NEXT:    [[TMP12:%.*]] = extractelement <4 x double> [[SPLIT]], i64 3
; RM-NEXT:    [[TMP13:%.*]] = insertelement <2 x double> undef, double [[TMP12]], i64 0
; RM-NEXT:    [[TMP14:%.*]] = extractelement <4 x double> [[SPLIT1]], i64 3
; RM-NEXT:    [[TMP15:%.*]] = insertelement <2 x double> [[TMP13]], double [[TMP14]], i64 1
; RM-NEXT:    [[TMP16:%.*]] = shufflevector <2 x double> [[TMP3]], <2 x double> [[TMP7]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; RM-NEXT:    [[TMP17:%.*]] = shufflevector <2 x double> [[TMP11]], <2 x double> [[TMP15]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; RM-NEXT:    [[TMP18:%.*]] = shufflevector <4 x double> [[TMP16]], <4 x double> [[TMP17]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; RM-NEXT:    ret <8 x double> [[TMP18]]
;
entry:
  %c  = call <8 x double> @llvm.matrix.transpose(<8 x double> %a, i32 2, i32 4)
  ret <8 x double> %c
}

declare <8 x double> @llvm.matrix.transpose(<8 x double>, i32, i32)

define <8 x double> @transpose_single_column(<8 x double> %a) {
; RM-LABEL: @transpose_single_column(
; RM-NEXT:  entry:
; RM-NEXT:    [[SPLIT:%.*]] = shufflevector <8 x double> [[A:%.*]], <8 x double> poison, <1 x i32> zeroinitializer
; RM-NEXT:    [[SPLIT1:%.*]] = shufflevector <8 x double> [[A]], <8 x double> poison, <1 x i32> <i32 1>
; RM-NEXT:    [[SPLIT2:%.*]] = shufflevector <8 x double> [[A]], <8 x double> poison, <1 x i32> <i32 2>
; RM-NEXT:    [[SPLIT3:%.*]] = shufflevector <8 x double> [[A]], <8 x double> poison, <1 x i32> <i32 3>
; RM-NEXT:    [[SPLIT4:%.*]] = shufflevector <8 x double> [[A]], <8 x double> poison, <1 x i32> <i32 4>
; RM-NEXT:    [[SPLIT5:%.*]] = shufflevector <8 x double> [[A]], <8 x double> poison, <1 x i32> <i32 5>
; RM-NEXT:    [[SPLIT6:%.*]] = shufflevector <8 x double> [[A]], <8 x double> poison, <1 x i32> <i32 6>
; RM-NEXT:    [[SPLIT7:%.*]] = shufflevector <8 x double> [[A]], <8 x double> poison, <1 x i32> <i32 7>
; RM-NEXT:    [[TMP0:%.*]] = extractelement <1 x double> [[SPLIT]], i64 0
; RM-NEXT:    [[TMP1:%.*]] = insertelement <8 x double> undef, double [[TMP0]], i64 0
; RM-NEXT:    [[TMP2:%.*]] = extractelement <1 x double> [[SPLIT1]], i64 0
; RM-NEXT:    [[TMP3:%.*]] = insertelement <8 x double> [[TMP1]], double [[TMP2]], i64 1
; RM-NEXT:    [[TMP4:%.*]] = extractelement <1 x double> [[SPLIT2]], i64 0
; RM-NEXT:    [[TMP5:%.*]] = insertelement <8 x double> [[TMP3]], double [[TMP4]], i64 2
; RM-NEXT:    [[TMP6:%.*]] = extractelement <1 x double> [[SPLIT3]], i64 0
; RM-NEXT:    [[TMP7:%.*]] = insertelement <8 x double> [[TMP5]], double [[TMP6]], i64 3
; RM-NEXT:    [[TMP8:%.*]] = extractelement <1 x double> [[SPLIT4]], i64 0
; RM-NEXT:    [[TMP9:%.*]] = insertelement <8 x double> [[TMP7]], double [[TMP8]], i64 4
; RM-NEXT:    [[TMP10:%.*]] = extractelement <1 x double> [[SPLIT5]], i64 0
; RM-NEXT:    [[TMP11:%.*]] = insertelement <8 x double> [[TMP9]], double [[TMP10]], i64 5
; RM-NEXT:    [[TMP12:%.*]] = extractelement <1 x double> [[SPLIT6]], i64 0
; RM-NEXT:    [[TMP13:%.*]] = insertelement <8 x double> [[TMP11]], double [[TMP12]], i64 6
; RM-NEXT:    [[TMP14:%.*]] = extractelement <1 x double> [[SPLIT7]], i64 0
; RM-NEXT:    [[TMP15:%.*]] = insertelement <8 x double> [[TMP13]], double [[TMP14]], i64 7
; RM-NEXT:    ret <8 x double> [[TMP15]]
;
entry:
  %c  = call <8 x double> @llvm.matrix.transpose(<8 x double> %a, i32 8, i32 1)
  ret <8 x double> %c
}

declare <12 x double> @llvm.matrix.transpose.v12f64(<12 x double>, i32, i32)

define <12 x double> @transpose_double_3x4(<12 x double> %a) {
; RM-LABEL: @transpose_double_3x4(
; RM-NEXT:  entry:
; RM-NEXT:    [[SPLIT:%.*]] = shufflevector <12 x double> [[A:%.*]], <12 x double> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; RM-NEXT:    [[SPLIT1:%.*]] = shufflevector <12 x double> [[A]], <12 x double> poison, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; RM-NEXT:    [[SPLIT2:%.*]] = shufflevector <12 x double> [[A]], <12 x double> poison, <4 x i32> <i32 8, i32 9, i32 10, i32 11>
; RM-NEXT:    [[TMP0:%.*]] = extractelement <4 x double> [[SPLIT]], i64 0
; RM-NEXT:    [[TMP1:%.*]] = insertelement <3 x double> undef, double [[TMP0]], i64 0
; RM-NEXT:    [[TMP2:%.*]] = extractelement <4 x double> [[SPLIT1]], i64 0
; RM-NEXT:    [[TMP3:%.*]] = insertelement <3 x double> [[TMP1]], double [[TMP2]], i64 1
; RM-NEXT:    [[TMP4:%.*]] = extractelement <4 x double> [[SPLIT2]], i64 0
; RM-NEXT:    [[TMP5:%.*]] = insertelement <3 x double> [[TMP3]], double [[TMP4]], i64 2
; RM-NEXT:    [[TMP6:%.*]] = extractelement <4 x double> [[SPLIT]], i64 1
; RM-NEXT:    [[TMP7:%.*]] = insertelement <3 x double> undef, double [[TMP6]], i64 0
; RM-NEXT:    [[TMP8:%.*]] = extractelement <4 x double> [[SPLIT1]], i64 1
; RM-NEXT:    [[TMP9:%.*]] = insertelement <3 x double> [[TMP7]], double [[TMP8]], i64 1
; RM-NEXT:    [[TMP10:%.*]] = extractelement <4 x double> [[SPLIT2]], i64 1
; RM-NEXT:    [[TMP11:%.*]] = insertelement <3 x double> [[TMP9]], double [[TMP10]], i64 2
; RM-NEXT:    [[TMP12:%.*]] = extractelement <4 x double> [[SPLIT]], i64 2
; RM-NEXT:    [[TMP13:%.*]] = insertelement <3 x double> undef, double [[TMP12]], i64 0
; RM-NEXT:    [[TMP14:%.*]] = extractelement <4 x double> [[SPLIT1]], i64 2
; RM-NEXT:    [[TMP15:%.*]] = insertelement <3 x double> [[TMP13]], double [[TMP14]], i64 1
; RM-NEXT:    [[TMP16:%.*]] = extractelement <4 x double> [[SPLIT2]], i64 2
; RM-NEXT:    [[TMP17:%.*]] = insertelement <3 x double> [[TMP15]], double [[TMP16]], i64 2
; RM-NEXT:    [[TMP18:%.*]] = extractelement <4 x double> [[SPLIT]], i64 3
; RM-NEXT:    [[TMP19:%.*]] = insertelement <3 x double> undef, double [[TMP18]], i64 0
; RM-NEXT:    [[TMP20:%.*]] = extractelement <4 x double> [[SPLIT1]], i64 3
; RM-NEXT:    [[TMP21:%.*]] = insertelement <3 x double> [[TMP19]], double [[TMP20]], i64 1
; RM-NEXT:    [[TMP22:%.*]] = extractelement <4 x double> [[SPLIT2]], i64 3
; RM-NEXT:    [[TMP23:%.*]] = insertelement <3 x double> [[TMP21]], double [[TMP22]], i64 2
; RM-NEXT:    [[TMP24:%.*]] = shufflevector <3 x double> [[TMP5]], <3 x double> [[TMP11]], <6 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5>
; RM-NEXT:    [[TMP25:%.*]] = shufflevector <3 x double> [[TMP17]], <3 x double> [[TMP23]], <6 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5>
; RM-NEXT:    [[TMP26:%.*]] = shufflevector <6 x double> [[TMP24]], <6 x double> [[TMP25]], <12 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11>
; RM-NEXT:    ret <12 x double> [[TMP26]]
;
entry:
  %c  = call <12 x double> @llvm.matrix.transpose.v12f64(<12 x double> %a, i32 3, i32 4)
  ret <12 x double> %c
}
