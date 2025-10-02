class ApiEndpoints {
  static const String baseUrl =
      'http://206.162.244.133:8041/api/v1/'; // Replace with actual base URL
  static const String baseImageUrl =
      'http://206.162.244.133:8041'; // Replace with actual base image URL

  // static const String baseUrl =
  //     'http://10.10.10.33:8041/api/v1/';
  // static const String baseImageUrl =
  //     'http://10.10.10.33:8041';

  //authentication
  static const String signin = "auth/signin";
  static const String signup = "auth/sign-up";

  static const String afterSignupOtp = "auth/verify-email";
  static const String forgetPassword = "auth/forget-password";
  static const String forgetPasswordOTP = "auth/verify-otp";

  static const String resetPassword = "auth/reset-password";
  static const String resendOtp = "auth/resend-otp";

  //personalization
  static const String sportsCategory = "/category/all";

  //profile
  static const String changePassword = "auth/change-password";

  static const String completeProfile = "users/complete";
  static const String getProfile = "users/user-details";

  static const String updateProfile = "users/update";
  static const String faq = "fandq/all";
  static const String addFeedback = "feedback/add";
  static const String badgeShelf = "ucm/my-achievements";

  //home page
  static const String homePage = "home";

  static String progress = "progress/full-progress";
  static const String addGoal = "/goal/add";

  static String staticContent(String type) => "static-contents?type=$type";
  static String workoutDetails(String id) => "workout/details-userend/$id";
  static const String completeVideo = "uvm";

  static const String startWorkout = "uwm/start";
  static String finishedWorkout(String id) => "uwm/finish/$id";

  static const String recentSessions = "uwm/mytraining";

  //training
  static const String training = "training/training";
  static const String changeCurrentTraining = "users/change-currentTrainning";

  //community
  static const String community = "community";
  static String activeChallenges({required int page, required int limit}) =>
      "challenge/active?page=$page&limit=$limit";
  static const String joinChallenge = "ucm/join";
  static const String leaderboard = "leaderboard";

  static String feed({required int page, required int limit}) =>
      "post/feed?limit=$limit&page=$page";

  static const String myPosts = "post/my-post";

  static const String createPost = "post/add";

  static const String likePost = "like/add";

  static const String commentPost = "comment/add";

  static String nutritionTracker = "food-goal/progress";

  static String setFoodGoal = "food-goal/add";

  static String runningGps = "running/create-run";

  static String shareRunning = "running/share";

  static String completedTrainings = "uwm/complete-list";

  static String myWorkout({required int page, required int limit}) =>
      "workout/suggestions?limit=$limit&page=$page";

  static String postDetails(String postId) => "post/details/$postId";

  static String updatePost(String postId) => "post/edit/$postId";
  static String deletePost(String postId) => "post/$postId";
  static String getCommentByPostId(String postId) => "post/comments/$postId";

  static String nutrationAdd = "nutration/add";

  static var subscriptions = "subscription/all";

  static String mySubscription = "my-subscription/my-sub";

  static String punchSubscription = "my-subscription/payment";
  static String paymentCompleate = "my-subscription/complete?";

  static String notifications({required int page, required int limit}) =>
      "notifications/notification-userend?page=$page&limit=$limit";

  static String runningHistory({required int page, required int limit}) {
    return "running/history?page=$page&limit=$limit";
  }

  static String host = "10.10.10.33";
  static int port = 8041;

  static String runSharingUrl(String runId) => "/running/$runId";

  static String getSharedRunDataUrl(String runId, String deviceSignature) =>
      "/running/$runId?deviceId=$deviceSignature";
}
