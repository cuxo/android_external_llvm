; RUN: llc %s -march arm64 -o - | FileCheck %s

@a = common global i32* null, align 8

define void @test(i32 %i, i32 %j) nounwind ssp {
entry:
  ; CHECK: @test
  %j.addr = alloca i32, align 4
  store i32 %j, i32* %j.addr, align 4, !tbaa !0
  %tmp = bitcast i32* %j.addr to i8*
  ; CHECK: prfum pldl1strm
  call void @llvm.prefetch(i8* %tmp, i32 0, i32 0, i32 1)
  ; CHECK: prfum pldl3keep
  call void @llvm.prefetch(i8* %tmp, i32 0, i32 1, i32 1)
  ; CHECK: prfum pldl2keep
  call void @llvm.prefetch(i8* %tmp, i32 0, i32 2, i32 1)
  ; CHECK: prfum pldl1keep
  call void @llvm.prefetch(i8* %tmp, i32 0, i32 3, i32 1)

  ; CHECK: prfum pstl1strm
  call void @llvm.prefetch(i8* %tmp, i32 1, i32 0, i32 1)
  ; CHECK: prfum pstl3keep
  call void @llvm.prefetch(i8* %tmp, i32 1, i32 1, i32 1)
  ; CHECK: prfum pstl2keep
  call void @llvm.prefetch(i8* %tmp, i32 1, i32 2, i32 1)
  ; CHECK: prfum pstl1keep
  call void @llvm.prefetch(i8* %tmp, i32 1, i32 3, i32 1)

  %tmp1 = load i32* %j.addr, align 4, !tbaa !0
  %add = add nsw i32 %tmp1, %i
  %idxprom = sext i32 %add to i64
  %tmp2 = load i32** @a, align 8, !tbaa !3
  %arrayidx = getelementptr inbounds i32* %tmp2, i64 %idxprom
  %tmp3 = bitcast i32* %arrayidx to i8*

  ; CHECK: prfm pldl1strm
  call void @llvm.prefetch(i8* %tmp3, i32 0, i32 0, i32 1)
  %tmp4 = load i32** @a, align 8, !tbaa !3
  %arrayidx3 = getelementptr inbounds i32* %tmp4, i64 %idxprom
  %tmp5 = bitcast i32* %arrayidx3 to i8*

  ; CHECK: prfm pldl3keep
  call void @llvm.prefetch(i8* %tmp5, i32 0, i32 1, i32 1)
  %tmp6 = load i32** @a, align 8, !tbaa !3
  %arrayidx6 = getelementptr inbounds i32* %tmp6, i64 %idxprom
  %tmp7 = bitcast i32* %arrayidx6 to i8*

  ; CHECK: prfm pldl2keep
  call void @llvm.prefetch(i8* %tmp7, i32 0, i32 2, i32 1)
  %tmp8 = load i32** @a, align 8, !tbaa !3
  %arrayidx9 = getelementptr inbounds i32* %tmp8, i64 %idxprom
  %tmp9 = bitcast i32* %arrayidx9 to i8*

  ; CHECK: prfm pldl1keep
  call void @llvm.prefetch(i8* %tmp9, i32 0, i32 3, i32 1)
  %tmp10 = load i32** @a, align 8, !tbaa !3
  %arrayidx12 = getelementptr inbounds i32* %tmp10, i64 %idxprom
  %tmp11 = bitcast i32* %arrayidx12 to i8*

  ; CHECK: prfm pstl1strm
  call void @llvm.prefetch(i8* %tmp11, i32 1, i32 0, i32 1)
  %tmp12 = load i32** @a, align 8, !tbaa !3
  %arrayidx15 = getelementptr inbounds i32* %tmp12, i64 %idxprom
  %tmp13 = bitcast i32* %arrayidx15 to i8*

  ; CHECK: prfm pstl3keep
  call void @llvm.prefetch(i8* %tmp13, i32 1, i32 1, i32 1)
  %tmp14 = load i32** @a, align 8, !tbaa !3
  %arrayidx18 = getelementptr inbounds i32* %tmp14, i64 %idxprom
  %tmp15 = bitcast i32* %arrayidx18 to i8*

  ; CHECK: prfm pstl2keep
  call void @llvm.prefetch(i8* %tmp15, i32 1, i32 2, i32 1)
  %tmp16 = load i32** @a, align 8, !tbaa !3
  %arrayidx21 = getelementptr inbounds i32* %tmp16, i64 %idxprom
  %tmp17 = bitcast i32* %arrayidx21 to i8*

  ; CHECK: prfm pstl1keep
  call void @llvm.prefetch(i8* %tmp17, i32 1, i32 3, i32 1)
  ret void
}

declare void @llvm.prefetch(i8* nocapture, i32, i32, i32) nounwind

!0 = metadata !{metadata !"int", metadata !1}
!1 = metadata !{metadata !"omnipotent char", metadata !2}
!2 = metadata !{metadata !"Simple C/C++ TBAA"}
!3 = metadata !{metadata !"any pointer", metadata !1}
