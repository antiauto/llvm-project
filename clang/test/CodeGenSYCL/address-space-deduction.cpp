// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -no-opaque-pointers -triple spir64 -fsycl-is-device -disable-llvm-passes -emit-llvm %s -o - | FileCheck %s

// CHECK-LABEL: @_Z4testv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[I:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[PPTR:%.*]] = alloca i32 addrspace(4)*, align 8
// CHECK-NEXT:    [[IS_I_PTR:%.*]] = alloca i8, align 1
// CHECK-NEXT:    [[VAR23:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[CP:%.*]] = alloca i8 addrspace(4)*, align 8
// CHECK-NEXT:    [[ARR:%.*]] = alloca [42 x i32], align 4
// CHECK-NEXT:    [[CPP:%.*]] = alloca i8 addrspace(4)*, align 8
// CHECK-NEXT:    [[APTR:%.*]] = alloca i32 addrspace(4)*, align 8
// CHECK-NEXT:    [[STR:%.*]] = alloca i8 addrspace(4)*, align 8
// CHECK-NEXT:    [[PHI_STR:%.*]] = alloca i8 addrspace(4)*, align 8
// CHECK-NEXT:    [[SELECT_NULL:%.*]] = alloca i8 addrspace(4)*, align 8
// CHECK-NEXT:    [[SELECT_STR_TRIVIAL1:%.*]] = alloca i8 addrspace(4)*, align 8
// CHECK-NEXT:    [[SELECT_STR_TRIVIAL2:%.*]] = alloca i8 addrspace(4)*, align 8
// CHECK-NEXT:    [[I_ASCAST:%.*]] = addrspacecast i32* [[I]] to i32 addrspace(4)*
// CHECK-NEXT:    [[PPTR_ASCAST:%.*]] = addrspacecast i32 addrspace(4)** [[PPTR]] to i32 addrspace(4)* addrspace(4)*
// CHECK-NEXT:    [[IS_I_PTR_ASCAST:%.*]] = addrspacecast i8* [[IS_I_PTR]] to i8 addrspace(4)*
// CHECK-NEXT:    [[VAR23_ASCAST:%.*]] = addrspacecast i32* [[VAR23]] to i32 addrspace(4)*
// CHECK-NEXT:    [[CP_ASCAST:%.*]] = addrspacecast i8 addrspace(4)** [[CP]] to i8 addrspace(4)* addrspace(4)*
// CHECK-NEXT:    [[ARR_ASCAST:%.*]] = addrspacecast [42 x i32]* [[ARR]] to [42 x i32] addrspace(4)*
// CHECK-NEXT:    [[CPP_ASCAST:%.*]] = addrspacecast i8 addrspace(4)** [[CPP]] to i8 addrspace(4)* addrspace(4)*
// CHECK-NEXT:    [[APTR_ASCAST:%.*]] = addrspacecast i32 addrspace(4)** [[APTR]] to i32 addrspace(4)* addrspace(4)*
// CHECK-NEXT:    [[STR_ASCAST:%.*]] = addrspacecast i8 addrspace(4)** [[STR]] to i8 addrspace(4)* addrspace(4)*
// CHECK-NEXT:    [[PHI_STR_ASCAST:%.*]] = addrspacecast i8 addrspace(4)** [[PHI_STR]] to i8 addrspace(4)* addrspace(4)*
// CHECK-NEXT:    [[SELECT_NULL_ASCAST:%.*]] = addrspacecast i8 addrspace(4)** [[SELECT_NULL]] to i8 addrspace(4)* addrspace(4)*
// CHECK-NEXT:    [[SELECT_STR_TRIVIAL1_ASCAST:%.*]] = addrspacecast i8 addrspace(4)** [[SELECT_STR_TRIVIAL1]] to i8 addrspace(4)* addrspace(4)*
// CHECK-NEXT:    [[SELECT_STR_TRIVIAL2_ASCAST:%.*]] = addrspacecast i8 addrspace(4)** [[SELECT_STR_TRIVIAL2]] to i8 addrspace(4)* addrspace(4)*
// CHECK-NEXT:    store i32 0, i32 addrspace(4)* [[I_ASCAST]], align 4
// CHECK-NEXT:    store i32 addrspace(4)* [[I_ASCAST]], i32 addrspace(4)* addrspace(4)* [[PPTR_ASCAST]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load i32 addrspace(4)*, i32 addrspace(4)* addrspace(4)* [[PPTR_ASCAST]], align 8
// CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 addrspace(4)* [[TMP0]], [[I_ASCAST]]
// CHECK-NEXT:    [[FROMBOOL:%.*]] = zext i1 [[CMP]] to i8
// CHECK-NEXT:    store i8 [[FROMBOOL]], i8 addrspace(4)* [[IS_I_PTR_ASCAST]], align 1
// CHECK-NEXT:    [[TMP1:%.*]] = load i32 addrspace(4)*, i32 addrspace(4)* addrspace(4)* [[PPTR_ASCAST]], align 8
// CHECK-NEXT:    store i32 66, i32 addrspace(4)* [[TMP1]], align 4
// CHECK-NEXT:    store i32 23, i32 addrspace(4)* [[VAR23_ASCAST]], align 4
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32 addrspace(4)* [[VAR23_ASCAST]] to i8 addrspace(4)*
// CHECK-NEXT:    store i8 addrspace(4)* [[TMP2]], i8 addrspace(4)* addrspace(4)* [[CP_ASCAST]], align 8
// CHECK-NEXT:    [[TMP3:%.*]] = load i8 addrspace(4)*, i8 addrspace(4)* addrspace(4)* [[CP_ASCAST]], align 8
// CHECK-NEXT:    store i8 41, i8 addrspace(4)* [[TMP3]], align 1
// CHECK-NEXT:    [[ARRAYDECAY:%.*]] = getelementptr inbounds [42 x i32], [42 x i32] addrspace(4)* [[ARR_ASCAST]], i64 0, i64 0
// CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32 addrspace(4)* [[ARRAYDECAY]] to i8 addrspace(4)*
// CHECK-NEXT:    store i8 addrspace(4)* [[TMP4]], i8 addrspace(4)* addrspace(4)* [[CPP_ASCAST]], align 8
// CHECK-NEXT:    [[TMP5:%.*]] = load i8 addrspace(4)*, i8 addrspace(4)* addrspace(4)* [[CPP_ASCAST]], align 8
// CHECK-NEXT:    store i8 43, i8 addrspace(4)* [[TMP5]], align 1
// CHECK-NEXT:    [[ARRAYDECAY1:%.*]] = getelementptr inbounds [42 x i32], [42 x i32] addrspace(4)* [[ARR_ASCAST]], i64 0, i64 0
// CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, i32 addrspace(4)* [[ARRAYDECAY1]], i64 10
// CHECK-NEXT:    store i32 addrspace(4)* [[ADD_PTR]], i32 addrspace(4)* addrspace(4)* [[APTR_ASCAST]], align 8
// CHECK-NEXT:    [[TMP6:%.*]] = load i32 addrspace(4)*, i32 addrspace(4)* addrspace(4)* [[APTR_ASCAST]], align 8
// CHECK-NEXT:    [[ARRAYDECAY2:%.*]] = getelementptr inbounds [42 x i32], [42 x i32] addrspace(4)* [[ARR_ASCAST]], i64 0, i64 0
// CHECK-NEXT:    [[ADD_PTR3:%.*]] = getelementptr inbounds i32, i32 addrspace(4)* [[ARRAYDECAY2]], i64 168
// CHECK-NEXT:    [[CMP4:%.*]] = icmp ult i32 addrspace(4)* [[TMP6]], [[ADD_PTR3]]
// CHECK-NEXT:    br i1 [[CMP4]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
// CHECK:       if.then:
// CHECK-NEXT:    [[TMP7:%.*]] = load i32 addrspace(4)*, i32 addrspace(4)* addrspace(4)* [[APTR_ASCAST]], align 8
// CHECK-NEXT:    store i32 44, i32 addrspace(4)* [[TMP7]], align 4
// CHECK-NEXT:    br label [[IF_END]]
// CHECK:       if.end:
// CHECK-NEXT:    store i8 addrspace(4)* getelementptr inbounds ([14 x i8], [14 x i8] addrspace(4)* addrspacecast ([14 x i8] addrspace(1)* @.str to [14 x i8] addrspace(4)*), i64 0, i64 0), i8 addrspace(4)* addrspace(4)* [[STR_ASCAST]], align 8
// CHECK-NEXT:    [[TMP8:%.*]] = load i8 addrspace(4)*, i8 addrspace(4)* addrspace(4)* [[STR_ASCAST]], align 8
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, i8 addrspace(4)* [[TMP8]], i64 0
// CHECK-NEXT:    [[TMP9:%.*]] = load i8, i8 addrspace(4)* [[ARRAYIDX]], align 1
// CHECK-NEXT:    [[CONV:%.*]] = sext i8 [[TMP9]] to i32
// CHECK-NEXT:    store i32 [[CONV]], i32 addrspace(4)* [[I_ASCAST]], align 4
// CHECK-NEXT:    [[TMP10:%.*]] = load i32, i32 addrspace(4)* [[I_ASCAST]], align 4
// CHECK-NEXT:    [[CMP5:%.*]] = icmp sgt i32 [[TMP10]], 2
// CHECK-NEXT:    br i1 [[CMP5]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
// CHECK:       cond.true:
// CHECK-NEXT:    [[TMP11:%.*]] = load i8 addrspace(4)*, i8 addrspace(4)* addrspace(4)* [[STR_ASCAST]], align 8
// CHECK-NEXT:    br label [[COND_END:%.*]]
// CHECK:       cond.false:
// CHECK-NEXT:    br label [[COND_END]]
// CHECK:       cond.end:
// CHECK-NEXT:    [[COND:%.*]] = phi i8 addrspace(4)* [ [[TMP11]], [[COND_TRUE]] ], [ getelementptr inbounds ([21 x i8], [21 x i8] addrspace(4)* addrspacecast ([21 x i8] addrspace(1)* @.str.1 to [21 x i8] addrspace(4)*), i64 0, i64 0), [[COND_FALSE]] ]
// CHECK-NEXT:    store i8 addrspace(4)* [[COND]], i8 addrspace(4)* addrspace(4)* [[PHI_STR_ASCAST]], align 8
// CHECK-NEXT:    [[TMP12:%.*]] = load i32, i32 addrspace(4)* [[I_ASCAST]], align 4
// CHECK-NEXT:    [[CMP6:%.*]] = icmp sgt i32 [[TMP12]], 2
// CHECK-NEXT:    [[TMP13:%.*]] = zext i1 [[CMP6]] to i64
// CHECK-NEXT:    [[COND7:%.*]] = select i1 [[CMP6]], i8 addrspace(4)* getelementptr inbounds ([24 x i8], [24 x i8] addrspace(4)* addrspacecast ([24 x i8] addrspace(1)* @.str.2 to [24 x i8] addrspace(4)*), i64 0, i64 0), i8 addrspace(4)* null
// CHECK-NEXT:    store i8 addrspace(4)* [[COND7]], i8 addrspace(4)* addrspace(4)* [[SELECT_NULL_ASCAST]], align 8
// CHECK-NEXT:    [[TMP14:%.*]] = load i8 addrspace(4)*, i8 addrspace(4)* addrspace(4)* [[STR_ASCAST]], align 8
// CHECK-NEXT:    store i8 addrspace(4)* [[TMP14]], i8 addrspace(4)* addrspace(4)* [[SELECT_STR_TRIVIAL1_ASCAST]], align 8
// CHECK-NEXT:    store i8 addrspace(4)* getelementptr inbounds ([21 x i8], [21 x i8] addrspace(4)* addrspacecast ([21 x i8] addrspace(1)* @.str.1 to [21 x i8] addrspace(4)*), i64 0, i64 0), i8 addrspace(4)* addrspace(4)* [[SELECT_STR_TRIVIAL2_ASCAST]], align 8
// CHECK-NEXT:    ret void
//
void test() {
  static const int foo = 0x42;


  int i = 0;
  int *pptr = &i;
  bool is_i_ptr = (pptr == &i);
  *pptr = foo;

  int var23 = 23;
  char *cp = (char *)&var23;
  *cp = 41;

  int arr[42];
  char *cpp = (char *)arr;
  *cpp = 43;

  int *aptr = arr + 10;
  if (aptr < arr + sizeof(arr))
    *aptr = 44;

  const char *str = "Hello, world!";

  i = str[0];

  const char *phi_str = i > 2 ? str : "Another hello world!";
  (void)phi_str;




  const char *select_null = i > 2 ? "Yet another Hello world" : nullptr;
  (void)select_null;

  const char *select_str_trivial1 = true ? str : "Another hello world!";
  (void)select_str_trivial1;

  const char *select_str_trivial2 = false ? str : "Another hello world!";
  (void)select_str_trivial2;
}
