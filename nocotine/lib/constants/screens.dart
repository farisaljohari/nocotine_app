enum Screens{
  root,
  login,
  importantQuestion,
  signup,
  mainScreen,
  home,
  profile,
  competition,
  AccountSettings,
  support,
  craetePost,
  comments,
  Posts,
  notification,
  otherProfile,
  searchbar,
  competitionSearch,
  IneedAsmookOptions,
  BooksLists,
  AdminHomeScreen,
  AdminNotificationScreen,
  AdminUsersScreen,
  AdminPostsScreen,
  AdminCompetitionScreen,
  AdminFeedbackScreen,
  AdminOnePost,
  AdminOneComment,
  AdminEditBooks,
  ForgetPassword,
  EditProfilePicture,
  ViewBookPDF
  
}
extension ScreenExtension on Screens{
  String get value{
    switch(this){
      case Screens.root:
        return "/";
      case Screens.login:
        return "/login";
      case Screens.importantQuestion:
        return "/importantQuestion";
      case Screens.signup:
        return "/signup";
      case Screens.mainScreen:
        return "/mainScreen";
      case Screens.competition:
        return "/competition";
      case Screens.profile:
        return "/profile";
      case Screens.AccountSettings:
        return "/accountSettings";
      case Screens.craetePost:
        return "/craetePost";
      case Screens.home:
        return "/home";
      case Screens.comments:
        return "/comments";
      case Screens.Posts:
        return "/posts";
      case Screens.support:
        return "/support";
      case Screens.notification:
        return "/notification";
      case Screens.otherProfile:
        return "/otherProfile";
      case Screens.competitionSearch:
        return "/competitionSearch";
      case Screens.IneedAsmookOptions:
        return "/IneedAsmookOptions";
      case Screens.BooksLists:
        return "/BooksLists"; 
      case Screens.searchbar:
        return "/searchbar";
      case Screens.AdminHomeScreen:
        return "/AdminHomeScreen";
      case Screens.AdminNotificationScreen:
        return "/AdminNotificationScreen";
      case Screens.AdminUsersScreen:
        return "/AdminUsersScreen";
      case Screens.AdminPostsScreen:
        return "/AdminPostsScreen";
      case Screens.AdminCompetitionScreen:
        return "/AdminCompetitionScreen";
      case Screens.AdminFeedbackScreen:
        return "/AdminFeedbackScreen";
      case Screens.AdminOnePost:
        return "/AdminOnePost";
      case Screens.AdminOneComment:
        return "/AdminOneComment";
      case Screens.AdminEditBooks:
        return "/AdminEditBooks";
      case Screens.ForgetPassword:
        return "/ForgetPassword";
      case Screens.EditProfilePicture:
        return "/EditProfilePicture"; 
      case Screens.ViewBookPDF:
        return "/ViewBookPDF";    
      default:
        return "/";
      
    }
  }
}