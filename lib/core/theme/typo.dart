import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

import '../values/colors.dart';

// 데이터테이블헤더
TextStyle dataTableHeaderTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 26,
  fontWeight: FontWeight.bold,
  fontFamily: 'Nunito',
);

// 영단어
TextStyle engWordTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 22,
  fontWeight: FontWeight.bold,
  fontFamily: 'Nunito',
);

TextStyle engWordCardTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 24,
  fontWeight: FontWeight.bold,
  fontFamily: 'Nunito',
);

TextStyle engSentenceTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
);

TextStyle engWordHighlightTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
);
// 발음기호
TextStyle engProunceTextStyle = TextStyle(
  color: Colors.blue,
  fontSize: 18,
  fontWeight: FontWeight.normal,
  fontFamily: 'Nunito',
);

TextStyle korPumsaTextStyle = TextStyle(
  color: Colors.blue,
  fontSize: 18,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

// 스와이퍼 카드 페이지 번호 텍스트
TextStyle swiperPageNumberTextStyle = TextStyle(
  color: Colors.green,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

// 강조 워드 스타일
TextStyle focusTextStyle = TextStyle(
  color: highlight_text_color,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

TextStyle nonFocusTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

TextStyle focusTextStyle1 = TextStyle(
  color: home_bg_color,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

// 콕아이디
TextStyle kokidTextStyle = TextStyle(
  color: Colors.orange,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Nunito',
);

// 복습 문장
TextStyle quizTextStyle1 = TextStyle(
  color: Colors.black87,
  fontSize: 18,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

TextStyle quizTextStyle2 = TextStyle(
  color: home_bg_color,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

TextStyle engEngTextStyle = TextStyle(
  color: Colors.blueAccent,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: 'Inter',
);

// 조회결과 안내: 데이터가 없다는 내용
TextStyle noDataIntroTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: Colors.black54,
);

// 로딩 중 ...
TextStyle loadingIntroTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: Colors.green,
);

// Next Button Text
TextStyle nextButtonTextStyle = TextStyle(
  color: Colors.white70,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

// 흰색 버튼 텍스트
TextStyle buttonTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: Colors.white,
);

// 영어문장
TextStyle engSentnceTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'Nunito',
);

// 영어단어 하이라이트
TextStyle engHighlightTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'Nunito',
);

// 한글문장
TextStyle korSentnceTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

// 한글단어 하이라이트
TextStyle korHighlightTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  fontFamily: 'Baemin4',
);

// 영영
TextStyle engEngSentnceTextStyle = TextStyle(
  color: home_bg_color,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  fontFamily: 'Nunito',
);

// 팝업 타이틀
TextStyle alertTitleTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);
TextStyle alertBodyTextStyle = TextStyle(
  color: Colors.green,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin1',
);
TextStyle alertButtonTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);
TextStyle alertErrorTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 14,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

// 얼럿 팝업 한글 폰트
TextStyle korTextStyle(Color color) {
  return TextStyle(
    color: color,
    fontSize: 18,
    fontWeight: FontWeight.normal,
    fontFamily: 'Baemin4',
  );
}

// 영어문장 단어 하이라이트  xxx 사용안함.
TextStyle highlightTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  fontFamily: 'Baemin4',
);

TextStyle appbarTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin1',
);

TextStyle appbarPulisherTextStyle = TextStyle(
  color: Colors.white70,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin1',
);

TextStyle appbarYellowTextStyle = TextStyle(
  color: Colors.yellow,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin1',
);

TextStyle bodyCenterTextStyle = TextStyle(
  color: home_bg_color,
  fontSize: 14,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin1',
);

TextStyle listTileTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

TextStyle latestListTileTextStyle = TextStyle(
  color: Colors.blue,
  fontSize: 18,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

TextStyle expansionTileTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);
// 강조텍스트 스타일
TextStyle expansionTileHighLightTextStyle = TextStyle(
  color: highlight_text_color,
  fontSize: 16,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);

TextStyle expansionTileLeadingNoStyle = TextStyle(
  color: Colors.black,
  fontSize: 12,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);

/*
노트 검색 textfield hint style
 */
TextStyle noteSearchHintTextStyle = TextStyle(
  color: Colors.white70,
  fontSize: 16,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);

/*
노트 검색 textfield label style
 */
TextStyle noteSearchLabelTextStyle = TextStyle(
  color: Colors.yellow,
  fontSize: 16,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);

/*
마지막 학습노트로 바로가기
 */
TextStyle latestNoteJumpStyle = TextStyle(
  color: Colors.green,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);
/*
홈스크린 메뉴 타이틀
 */
TextStyle homeMenuTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 24,
  fontWeight: FontWeight.w500,
  fontFamily: 'Baemin4',
);

/*
퀴즈 문제
 */
TextStyle quiz1TextStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'BaeminEuljiro',
);
TextStyle quiz2TextStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'BaeminEuljiro',
);

TextStyle quiz2OrangeTextStyle = TextStyle(
  color: Colors.orange,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'BaeminEuljiro',
);

TextStyle quiz2WhiteTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'BaeminEuljiro',
);

/*
오답추가
 */
TextStyle odabAddStyle = TextStyle(
  color: Colors.red,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

/*
사용자과목추가
 */
TextStyle subjectAddTitleTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);
TextStyle subjectAddNameTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);

TextStyle subjectAddButtonTextStyle = TextStyle(
  color: text_yellow_color,
  fontSize: 20,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);

/*
오늘의 퀴즈 순위
 */
TextStyle rankNoTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.w100,
  fontFamily: 'BaeminAir',
);

TextStyle rankNoBoldTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  fontFamily: 'BaeminAir',
);

TextStyle rankNickNameStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);

TextStyle rankStartTimeStyle = TextStyle(
  color: Colors.black,
  fontSize: 12,
  fontWeight: FontWeight.w100,
  fontFamily: 'BaeminEuljiro',
);

TextStyle rankJeongdabCountStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);

/*
퀴즈결과
 */

TextStyle quizResultStatStyle = TextStyle(
  color: Colors.yellow,
  fontSize: 50,
  fontWeight: FontWeight.w100,
  fontFamily: 'BaeminEuljiro',
);

TextStyle quizInfoStyle = TextStyle(
  color: Colors.teal,
  fontSize: 18,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);
/*
닉네임
 */
TextStyle nickNameTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'BaeminEuljiro',
);

TextStyle nickName1TextStyle = TextStyle(
  color: Colors.white.withValues(alpha: 0.9),
  fontSize: 14,
  fontWeight: FontWeight.w500,
  fontFamily: 'BaeminEuljiro',
);

TextStyle nickName2TextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
  fontFamily: 'BaeminEuljiro',
);

TextStyle elebatedButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w500,
  fontFamily: 'BaeminEuljiro',
);

/*
콕비밀번호 설정
 */
TextStyle passwdIntroStyle = TextStyle(
  color: Colors.black54,
  fontSize: 18,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);

/*
약관
 */
TextStyle settingListTileTitleStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

/*
통계보기
 */
TextStyle statViewTitleStyle = TextStyle(
  color: Color.fromRGBO(0x8D, 0x4E, 0x22, 1),
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
  decoration: TextDecoration.underline,
  decorationColor: Colors.blueGrey,
  // Colors.green
);

/*
일반적인 검정색 텍스트
 */
TextStyle normalTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);
TextStyle normal14TextStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

TextStyle normal16WhiteTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

TextStyle normal16RedTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

/*
퀴즈 구독 후 이용 안내
 */
TextStyle normalColorTextStyle = TextStyle(
  color: home_bg_color,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);
TextStyle normal14ColorTextStyle = TextStyle(
  color: home_bg_color,
  fontSize: 14,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);
TextStyle normal18ColorTextStyle = TextStyle(
  color: home_bg_color,
  fontSize: 18,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

/*
snackbar
 */
TextStyle snackBarLabelTextStyle = TextStyle(
  color: Colors.yellow,
  fontSize: 14,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);
/*
설정
 */
TextStyle versionInfoStyle = TextStyle(
  color: Colors.black,
  fontSize: 12,
  fontWeight: FontWeight.w100,
  fontFamily: 'BaeminEuljiro',
);

/*
순위보기
 */
TextStyle rankBogiLabelTextStyle = TextStyle(
  color: Colors.yellow,
  fontSize: 14,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);

/*
구독하러가기
 */
TextStyle gotoSubscriptionTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w100,
  fontFamily: 'Baemin4',
);
/*
퀴즈 풀이: 정답, 오답안내
 */
TextStyle quizCorrectTextStyle = TextStyle(
  color: home_bg_color,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin1',
);
TextStyle quizWrongTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin1',
);

/*
퀴즈 통계
 */
TextStyle quizStatViewTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

/*
얼럿
 */
TextStyle alertTitleStyle = TextStyle(
  color: Colors.black54,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: 'BaeminEuljiro',
);

TextStyle alertBodyStyle = TextStyle(
  color: Colors.black54,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);
TextStyle alertButtonStyle = TextStyle(
  color: Colors.white70,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  fontFamily: 'Baemin4',
);

TextStyle alertIosButtonStyle = TextStyle(
  color: Colors.blue,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

// 안드로이드
TextStyle alertAosTitleTextStyle = TextStyle(fontSize: 18, color: Colors.black);

TextStyle alertAosContentTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

TextStyle alertAosBtnTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.blueAccent,
);
// 아이폰
TextStyle alertIosTitleTextStyle = TextStyle(fontSize: 18, color: Colors.black);

TextStyle alertIosContentTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

TextStyle alertIosBtnTextStyle = TextStyle(fontSize: 16, color: Colors.blue);

TextStyle alertDefaultTitleTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

TextStyle alertDefaultContentTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

TextStyle alertDefaultBtnTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.blueAccent,
);

TextStyle alertDefaultDeleteBtnTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.red,
);

/*
닉네임 입력
 */
TextStyle nickNameInputTextStyle = TextStyle(
  color: home_bg_color,
  fontSize: 18,
  fontWeight: FontWeight.normal, //,fontFamily: 'Baemin4'
);

/*
안드로이드 얼럿 버튼 스타일
버튼 컬러 white
 */
ButtonStyle aosAlertBtnStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
);

/*
퀴즈풀이 정답입력 테스트
 */
TextStyle quizJeongDabInputTextStyle(bool flag) {
  return TextStyle(
    color: flag ? home_bg_color : Colors.red,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}

/*
콕비밀번호 설정 주의사항
 */
TextStyle kokPasswdSettingTextStyle = TextStyle(
  color: Colors.green,
  fontSize: 14,
  fontWeight: FontWeight.w100,
);

/*
퀴즈홈으로 가기
 */
TextStyle odabNomoreTextStyle(bool flag) {
  return TextStyle(
    color: (flag) ? Colors.white : Colors.red,
    fontSize: (flag) ? 18 : 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'Baemin4',
  );
}

TextStyle quizHomeGoTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  fontFamily: 'Baemin4',
);
