;RUN: %opt < %s %loadEnzyme -enzyme -mem2reg -instsimplify -simplifycfg -S | FileCheck %s

;#include <cblas.h>
;
;extern double __enzyme_autodiff(void *, double *, double *, double *, double *,
;                               double *, double *, double, double);
;
;void g(double *restrict A, double *restrict B, double *C, double alpha, double beta) {
;  cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, 2, 2, 3, alpha, A, 3,
;              B, 2, beta, C, 2);
;}
;
;int main() {
;  double A[] = {0.11, 0.12, 0.13, 0.21, 0.22, 0.23};
;  double B[] = {1011, 1012, 1021, 1022, 1031, 1032};
;  double C[] = {0.00, 0.00, 0.00, 0.00};
;  double A1[] = {0, 0, 0, 0, 0, 0};
;  double B1[] = {0, 0, 0, 0, 0, 0};
;  double C1[] = {1, 3, 7, 11};
;  __enzyme_autodiff((void *)g, A, A1, B, B1, C, C1, 2.0, 3.0);
;}

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@__const.main.C1 = private unnamed_addr constant [4 x double] [double 1.000000e+00, double 3.000000e+00, double 7.000000e+00, double 1.100000e+01], align 16

define dso_local void @g(double* noalias %A, double* noalias %B, double* %C, double %alpha, double %beta) {
entry:
  %A.addr = alloca double*, align 8
  %B.addr = alloca double*, align 8
  %C.addr = alloca double*, align 8
  %alpha.addr = alloca double, align 8
  %beta.addr = alloca double, align 8
  store double* %A, double** %A.addr, align 8
  store double* %B, double** %B.addr, align 8
  store double* %C, double** %C.addr, align 8
  store double %alpha, double* %alpha.addr, align 8
  store double %beta, double* %beta.addr, align 8
  %0 = load double, double* %alpha.addr, align 8
  %1 = load double*, double** %A.addr, align 8
  %2 = load double*, double** %B.addr, align 8
  %3 = load double, double* %beta.addr, align 8
  %4 = load double*, double** %C.addr, align 8
  call void @cblas_dgemm(i32 101, i32 111, i32 111, i32 2, i32 2, i32 3, double %0, double* %1, i32 3, double* %2, i32 2, double %3, double* %4, i32 2)
  ret void
}

declare dso_local void @cblas_dgemm(i32, i32, i32, i32, i32, i32, double, double*, i32, double*, i32, double, double*, i32)

define dso_local i32 @main() {
entry:
  %A = alloca [6 x double], align 16
  %B = alloca [6 x double], align 16
  %C = alloca [4 x double], align 16
  %A1 = alloca [6 x double], align 16
  %B1 = alloca [6 x double], align 16
  %C1 = alloca [4 x double], align 16
  %0 = bitcast [6 x double]* %A to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %0, i8 0, i64 48, i1 false)
  %1 = bitcast i8* %0 to [6 x double]*
  %2 = getelementptr inbounds [6 x double], [6 x double]* %1, i32 0, i32 0
  store double 1.100000e-01, double* %2, align 16
  %3 = getelementptr inbounds [6 x double], [6 x double]* %1, i32 0, i32 1
  store double 1.200000e-01, double* %3, align 8
  %4 = getelementptr inbounds [6 x double], [6 x double]* %1, i32 0, i32 2
  store double 1.300000e-01, double* %4, align 16
  %5 = getelementptr inbounds [6 x double], [6 x double]* %1, i32 0, i32 3
  store double 2.100000e-01, double* %5, align 8
  %6 = getelementptr inbounds [6 x double], [6 x double]* %1, i32 0, i32 4
  store double 2.200000e-01, double* %6, align 16
  %7 = getelementptr inbounds [6 x double], [6 x double]* %1, i32 0, i32 5
  store double 2.300000e-01, double* %7, align 8
  %8 = bitcast [6 x double]* %B to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %8, i8 0, i64 48, i1 false)
  %9 = bitcast i8* %8 to [6 x double]*
  %10 = getelementptr inbounds [6 x double], [6 x double]* %9, i32 0, i32 0
  store double 1.011000e+03, double* %10, align 16
  %11 = getelementptr inbounds [6 x double], [6 x double]* %9, i32 0, i32 1
  store double 1.012000e+03, double* %11, align 8
  %12 = getelementptr inbounds [6 x double], [6 x double]* %9, i32 0, i32 2
  store double 1.021000e+03, double* %12, align 16
  %13 = getelementptr inbounds [6 x double], [6 x double]* %9, i32 0, i32 3
  store double 1.022000e+03, double* %13, align 8
  %14 = getelementptr inbounds [6 x double], [6 x double]* %9, i32 0, i32 4
  store double 1.031000e+03, double* %14, align 16
  %15 = getelementptr inbounds [6 x double], [6 x double]* %9, i32 0, i32 5
  store double 1.032000e+03, double* %15, align 8
  %16 = bitcast [4 x double]* %C to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %16, i8 0, i64 32, i1 false)
  %17 = bitcast [6 x double]* %A1 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %17, i8 0, i64 48, i1 false)
  %18 = bitcast [6 x double]* %B1 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %18, i8 0, i64 48, i1 false)
  %19 = bitcast [4 x double]* %C1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %19, i8* align 16 bitcast ([4 x double]* @__const.main.C1 to i8*), i64 32, i1 false)
  %arraydecay = getelementptr inbounds [6 x double], [6 x double]* %A, i32 0, i32 0
  %arraydecay1 = getelementptr inbounds [6 x double], [6 x double]* %A1, i32 0, i32 0
  %arraydecay2 = getelementptr inbounds [6 x double], [6 x double]* %B, i32 0, i32 0
  %arraydecay3 = getelementptr inbounds [6 x double], [6 x double]* %B1, i32 0, i32 0
  %arraydecay4 = getelementptr inbounds [4 x double], [4 x double]* %C, i32 0, i32 0
  %arraydecay5 = getelementptr inbounds [4 x double], [4 x double]* %C1, i32 0, i32 0
  %call = call double @__enzyme_autodiff(i8* bitcast (void (double*, double*, double*, double, double)* @g to i8*), double* %arraydecay, double* %arraydecay1, double* %arraydecay2, double* %arraydecay3, double* %arraydecay4, double* %arraydecay5, double 2.000000e+00, double 3.000000e+00)
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1)

declare dso_local double @__enzyme_autodiff(i8*, double*, double*, double*, double*, double*, double*, double, double)

;CHECK:define internal { double, double } @diffeg(double* noalias %A, double* %"A'", double* noalias %B, double* %"B'", double* %C, double* %"C'", double %alpha, double %beta) {
;CHECK-NEXT:entry:
;CHECK-NEXT:  call void @cblas_dgemm(i32 101, i32 111, i32 111, i32 2, i32 2, i32 3, double %alpha, double* nocapture readonly %A, i32 3, double* nocapture readonly %B, i32 2, double %beta, double* %C, i32 2)
;CHECK-NEXT:  call void @cblas_dgemm(i32 101, i32 111, i32 112, i32 2, i32 3, i32 2, double %alpha, double* nocapture readonly %"C'", i32 2, double* nocapture readonly %B, i32 2, double 1.000000e+00, double* %"A'", i32 3)
;CHECK-NEXT:  call void @cblas_dgemm(i32 101, i32 112, i32 111, i32 3, i32 2, i32 2, double %alpha, double* nocapture readonly %A, i32 3, double* nocapture readonly %"C'", i32 2, double 1.000000e+00, double* %"B'", i32 2)
;CHECK-NEXT:  call void @cblas_dscal(i32 4, double %beta, double* %"C'", i32 1)
;CHECK-NEXT:  ret { double, double } zeroinitializer
;CHECK-NEXT:}
