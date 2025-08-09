  import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

  Widget challengeCard(String title, String status, int participants, int daysLeft, double? progress,{required Function()? onTap}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              commonText(title, size: 14, isBold: true),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == "Joined" ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(width: 1,color: Colors.grey.withOpacity(0.5))
                  ),
                  child: commonText(status, size: 12,),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.groups, size: 16,color: AppColors.primary,),
              const SizedBox(width: 4),
              commonText("$participants Participations", size: 12),
              const SizedBox(width: 12),
              commonText("$daysLeft Days Left", size: 12),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                commonText("Progress", size: 12,color: AppColors.textSecondary),
                commonText("5/7 Days", size: 12,color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,minHeight: 12,
              borderRadius: BorderRadius.circular(16),
              backgroundColor: AppColors.boxBG,
              color: AppColors.primary,
            ),
          ],
        ],
      ),
    );
  }

  Widget postCard({required String user, required String time, String? tag,bool myPost=false,required Function()? ontap}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20,backgroundImage: NetworkImage("https://plus.unsplash.com/premium_photo-1664297814064-661d433c03d9?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonText(user, size: 14, isBold: true),
                    commonText(time, size: 12, color: AppColors.textSecondary),
                  ],
                ),
              ),

              if (tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: commonText(tag, size: 12),
                ),
              if(myPost)...[SizedBox(width: 6,), Icon(Icons.edit),SizedBox(width: 4,),
              Icon(Icons.delete_outline_rounded)]
            ],
          ),
          const SizedBox(height: 12),
          commonText(
            "Just completed my first 5K run today! 🏃‍♂️ The feeling of crossing that finish line was incredible. Started training just 2 months ago and couldn’t even run for 5 minutes straight. Now look at me!",
            size: 13,maxline: 4
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.favorite_border, size: 16),
              const SizedBox(width: 4),
              commonText("15", size: 12),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: ontap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mode_comment_outlined, size: 16),
                    const SizedBox(width: 4),
                    commonText("6", size: 12),
                  ],
                )),
             
            ],
          )
        ],
      ),
    );
  }

  Widget leaderboardCard({
    required num points,
    required num index,
    required String name,
  }) {
    // Image URLs for top 3 ranks
    final trophyImages = [
      "assest/images/community/rank_1st.png", // 🥇 1st
      "assest/images/community/rank_2nd.png", // 🥈 2nd
      "assest/images/community/rank_3rd.png", // 🥉 3rd
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (index < 3)
            CommonImage(
              imagePath: trophyImages[index.toInt()],
              width: 32,
              isAsset: true,
            
            )
          else
            SizedBox(
              width: 32,
              child: Center(
                child: commonText(
                  "${index + 1}",
                  size: 16,
                  isBold: true,
                ),
              ),
            ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              "https://plus.unsplash.com/premium_photo-1664297814064-661d433c03d9?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: commonText(name, size: 14),
          ),
          commonText(
            "$points\nPoints",
            size: 14,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget sectionHeader(String title,{required Function()? onTap}) {
    return Row(
      
      children: [
        Expanded(child: commonText(title, size: 16, isBold: true,maxline: 1)),
        GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              commonText("See all "),
              const Icon(Icons.arrow_forward, size: 14,color: AppColors.primary,),
            ],
          ),
        ),
      ],
    );
  }

  void showChallengeDetailsBottomSheet(BuildContext context,{required bool isJoined}) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(child: commonText("Challenge Details", size: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
            
                commonText("About This Challenge", size: 16, fontWeight: FontWeight.w600),
                const SizedBox(height: 8),
                commonText(
                  "Improve your soccer skills with daily drills and exercises. Perfect for players of all levels looking to enhance their technique and fitness.",
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
            
                commonText("Time", size: 16, fontWeight: FontWeight.w600),
                const SizedBox(height: 4),
                commonText("1 Week", size: 14),
                SizedBox(height: 12,),
                commonText("Rewards", size: 16, fontWeight: FontWeight.w600),
                const SizedBox(height: 4),
                commonText("Achievement Badge\n200 Points", size: 14),
            
                const SizedBox(height: 30),
                if(isJoined)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Join Challenge action
                      Navigator.pop(context);
                    },
                    child: commonText(
                      "Join Challenge",
                      size: 15,
                      
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            Positioned(
              top: 0,
              right: 0,
              child: commonCloseButton()),
          ],
        ),
      ),
    );
  }


void showCommentsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: AppColors.white,
    builder: (context) {
      final TextEditingController _commentController = TextEditingController();

      final List<Map<String, String>> comments = List.generate(
        4,
        (_) => {
          "name": "Maude Hall",
          "time": "14 min",
          "comment":
              "That's a fantastic new app feature. You and your team did an excellent job of incorporating user testing feedback.",
          "image":
              "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=500",
        },
      );

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Stack(

          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: commonText("Comments", size: 18, isBold: true)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: comments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    NetworkImage(comment["image"]!),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        commonText(comment["name"]!,
                                            size: 14, fontWeight: FontWeight.w600),
                                        commonText(comment["time"]!,
                                            size: 12,
                                            color: AppColors.textSecondary),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    commonText(comment["comment"]!,
                                        size: 13,
                                        color: AppColors.textPrimary,
                                        maxline: 5
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      commonTextField(
                        hintText: "Type your comment here",
                        controller: _commentController,
                        minLine: 4,
                                      
                      ),    Positioned(
                        bottom: 10,right: 10,
                        child: GestureDetector(
                                        onTap:(){} ,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color:  AppColors.primary,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(width: 1,color: Colors.grey.withOpacity(0.5))
                                          ),
                                          child: commonText("Send", size: 16,color: AppColors.white),
                                        ),
                                      ),
                      )
                    ],
                  ),
                  SizedBox(height: 8,)
                ],
              ),
            ),
        
        Positioned(
          top: 10,right: 10,
          child: commonCloseButton())
          ],
        ),
      );
    },
  );
}




