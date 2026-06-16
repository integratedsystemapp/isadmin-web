import 'package:flutter/material.dart';
// 'dart:ui'가 없음

/*
const PAGE_UNIT = 800; // 노트 페이지 가져오는 단위
enum FilterModeState { favorite, mynote, none }
enum SubjectScreenModeState { product, user }

const BUCKET_NAME = 'kokca_bucket';
const BUCKET_IMAGE_FOLDER_NAME = 'image';
const BUCKET_PROFILE_IMAGE_FOLDER_NAME = 'profile_image';
const LOCAL_APP_FOLDER_NAME = 'app';
const BUCKET_WORD_IMAGE_FOLDER_NAME = 'word_image';
const BUCKET_WORD_IMAGE_SIZE = '300';        // 디폴트 이미지 사이즈
const BUCKET_WORD_IMAGE_THUMB_SIZE = '80';   // 썸네일 이미지 사이즈

const BUCKET_EXPORT_FOLDER_NAME = 'export';
const BUCKET_MANUAL_FOLDER_NAME = 'app';
const BUCKET_APP_FOLDER_NAME = 'app';

const MANUAL_FILE_NAME = 'kokca_manual.pdf';
*/
// 등록, 수정, 삭제 alertDialog 내 SingleChildScrollView의 오른쪽 스크롤 여백 설정
const SCROLL_BAR_MARGIN = 16.0;
const DATETIME_WIDTH = 150;  // 생성일, 수정일, ...
const BUILDING_CD_WIDTH = 150; // 빌딩 코드
const NAME_WIDTH = 150;        // 빌딩명, 수신자명


const APP_ICON_COLOR = Color(0xFFFFE3E2); // 앱 아이콘 색상
const IS_DEBUG = true;
//
const HEADER_COLOR = Color(0xFF1E293B); // 상단
const SIDEBAR_COLOR = Color(0xFFF1F5F9);  // 왼쪽 버튼 영역
const BUTTONAREA_COLOR = Color(0xFFF8FAFC);  // 등록, 수정, 삭제 버튼영역
const CONTENTAREA_COLOR = Color(0xFFFFFFFF); // 표 영역
// 상단 버튼 컬러
const BUTTON_COLOR  = Color(0xFF3B82F6);
const BUTTON_HOVER_COLOR  = Color(0xFF2563EB);

// 데이터테이블 상단과 좌우 여백
const DATATABLE_MARGIN = 3.0;
const EFORMSIGN_DOC_ID = '94f051bc564a4c369d901cc0f73f5636';
const LOGIN_ID_KEY = 'login_id'; // getx storage

/*
🎨 Snackbar 컬러 추천 (Hex)
1. Success (성공 알림)

배경: #10B981 (Emerald 500)

텍스트: #FFFFFF (화이트)

→ 등록 성공, 저장 완료 등에 사용

2. Error (오류/실패 알림)

배경: #EF4444 (Red 500)

텍스트: #FFFFFF

→ 로그인 실패, 삭제 오류 등에 사용

3. Warning (주의/경고 알림)

배경: #F59E0B (Amber 500)

텍스트: #FFFFFF

→ 필수 입력 누락, 제한 사항 알림 등에 사용

4. Info (정보 알림, 기본 스타일)

배경: #1E293B (Slate 800, 상단바 컬러와 통일)

텍스트: #FFFFFF

→ 단순 안내 메시지 (예: "저장되었습니다")
 */

