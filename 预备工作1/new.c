; ModuleID = 'try.c'
source_filename = "try.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable

define dso_local i32 @main() #0 {
  ; 数组声明 float a[10];
  %1 = alloca [10 x float], align 16
  ; 指针声明 float* p = (float*)malloc(10 * sizeof(float));
  %2 = alloca float*, align 8
  ; 调用全局函数@malloc动态分配空间
  %3 = call noalias i8* @malloc(i64 40) #2
  ; The ‘bitcast’ instruction converts value to type ty2 without changing any bits.
  %4 = bitcast i8* %3 to float*
  store float* %4, float** %2, align 8
  
  %5 = alloca i32, align 4
  store i32 0, i32* %5, align 4
  %6 = alloca [10 x int], align 16
  br label %7

7:                                                ; preds = %42, %0
  %8 = load i32, i32* %5, align 4
  %9 = icmp slt i32 %8, 10
  br i1 %9, label %10, label %45

10:                                               ; preds = %7
  %11 = load i32, i32* %5, align 4
  %12 = sitofp i32 %11 to float
  %13 = load i32, i32* %5, align 4
  %14 = sext i32 %13 to i64
  %15 = getelementptr inbounds [10 x float], [10 x float]* %2, i64 0, i64 %14
  store float %12, float* %15, align 4
  %16 = load i32, i32* %5, align 4
  %17 = sub nsw i32 10, %16
  %18 = sitofp i32 %17 to float
  %19 = load float*, float** %3, align 8
  %20 = load i32, i32* %5, align 4
  %21 = sext i32 %20 to i64
  %22 = getelementptr inbounds float, float* %19, i64 %21
  store float %18, float* %22, align 4
  %23 = load i32, i32* %5, align 4
  %24 = sext i32 %23 to i64
  %25 = getelementptr inbounds [10 x float], [10 x float]* %2, i64 0, i64 %24
  %26 = load float, float* %25, align 4
  %27 = load float*, float** %3, align 8
  %28 = load i32, i32* %5, align 4
  %29 = sext i32 %28 to i64
  %30 = getelementptr inbounds float, float* %27, i64 %29
  %31 = load float, float* %30, align 4
  %32 = fcmp oeq float %26, %31
  br i1 %32, label %33, label %41

33:                                               ; preds = %10
  %34 = load i32, i32* %5, align 4
  %35 = sext i32 %34 to i64
  %36 = getelementptr inbounds [10 x float], [10 x float]* %2, i64 0, i64 %35
  store float -1.000000e+00, float* %36, align 4
  %37 = load float*, float** %3, align 8
  %38 = load i32, i32* %5, align 4
  %39 = sext i32 %38 to i64
  %40 = getelementptr inbounds float, float* %37, i64 %39
  store float -1.000000e+00, float* %40, align 4
  br label %41

41:                                               ; preds = %33, %10
  br label %42

42:                                               ; preds = %41
  %43 = load i32, i32* %4, align 4
  %44 = add nsw i32 %43, 1
  store i32 %44, i32* %4, align 4
  br label %7

14:                                               ; preds = %7
  ret i32 0
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}