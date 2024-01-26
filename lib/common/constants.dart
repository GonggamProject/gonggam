import 'dart:ui';

import 'package:flutter/material.dart';

const IMAGE_PATH = "assets/images";
const FONT_SFPRO = "SF Pro";
const FONT_NANUMMYNGJO = "Nanum Myngjo";
const FONT_APPLESD = "Apple SD Gothic Neo";
const FONT_BODONI_BOLD = "Bodoni Bold";
const FONT_BODONI_BOOK = "Bodoni Book";

//TODO 이거 정확하게 어떻게 동작하는지 봐야겠다. safearea가 있는 애들한테만 이게 먹혔으면함
const PADDING_MINIMUM_SAFEAREA = EdgeInsets.fromLTRB(27, 0, 27, 0);

const MAX_USER_PER_STORE = 5;
const MAX_NOTE_COUNT = 5;

const MAX_NICKNAME_LENGTH = 10;
const MAX_GROUPNAME_LENGTH = 10;

const COLOR_BACKGROUND = Color(0xFFFFFFFF);
const COLOR_SPLASH_BACKGROUND = Color(0xFFEFEFEF);
const COLOR_SUB = Color(0xFF676767);
const COLOR_SUB1 = Color(0xFF333333);

const COLOR_BOOK1 = Color(0xFFF7E0DB);
const COLOR_BOOK2 = Color(0xFFF5CDC3);
const COLOR_BOOK3 = Color(0xFFDF8C70);
const COLOR_BOOK4 = Color(0xFFC9653C);
const COLOR_BOOK5 = Color(0xFF395446);

const COLOR_BOOKS = [COLOR_BOOK1, COLOR_BOOK2, COLOR_BOOK3, COLOR_BOOK4, COLOR_BOOK5];

const COLOR_GRAY = Color(0xFFB4B4B4);
const COLOR_LIGHTGRAY = Color(0xFFEFEFEF);
const COLOR_BLUE = Color(0xFF167CC7);
//walkthrough
const WALKTHROUGH_COLOR_DOT = Color(0xFFE1E1E1);
const WALKTHROUGH_COLOR_DOT_ACTIVE = Color(0xFFC9653C);
const WALKTHROUGH_FONT_SIZE = 18.0;

// link
const LINK_PRIVACY = "https://gonggam.me/privacy";
const LINK_TERMS = "https://gonggam.me/terms";
const LINK_INTRODUCE = "https://gonggam.me/introduce";
const LINL_HOWTOUSE = "https://gonggam.me/howtouse";
const LINK_MAKERS = "https://gonggam.me/makers";
const LINK_QNA = "https://gonggam.me/qna";

// url
// const SERVER_URL = "https://port-0-gonggam-server-ac2nll600wrs.sel3.cloudtype.app";
const SERVER_URL = "http://43.201.183.55:8080";
const S3_URL = "https://gonggamimage.s3.ap-northeast-2.amazonaws.com";