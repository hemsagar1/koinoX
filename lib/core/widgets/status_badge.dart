import 'package:flutter/material.dart';
import '../models/complaint_model.dart';
import '../models/request_model.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  factory StatusBadge.fromComplaintStatus(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.waitingForSync:
        return const StatusBadge(
          label: 'Waiting for sync',
          backgroundColor: Color(0xFFFFEDD5),
          textColor: Color(0xFFC2410C),
          icon: Icons.sync_problem,
        );
      case ComplaintStatus.submitted:
        return const StatusBadge(
          label: 'Submitted',
          backgroundColor: Color(0xFFE0F2FE),
          textColor: Color(0xFF0369A1),
          icon: Icons.send_rounded,
        );
      case ComplaintStatus.assigned:
        return const StatusBadge(
          label: 'Assigned',
          backgroundColor: Color(0xFFFEF3C7),
          textColor: Color(0xFFB45309),
          icon: Icons.person_add_alt_1_rounded,
        );
      case ComplaintStatus.inProgress:
        return const StatusBadge(
          label: 'In Progress',
          backgroundColor: Color(0xFFE0E7FF),
          textColor: Color(0xFF4338CA),
          icon: Icons.autorenew_rounded,
        );
      case ComplaintStatus.resolved:
        return const StatusBadge(
          label: 'Resolved',
          backgroundColor: Color(0xFFD1FAE5),
          textColor: Color(0xFF047857),
          icon: Icons.check_circle_rounded,
        );
    }
  }

  factory StatusBadge.fromRequestStatus(RequestStatus status) {
    switch (status) {
      case RequestStatus.submitted:
        return const StatusBadge(
          label: 'Submitted',
          backgroundColor: Color(0xFFE0F2FE),
          textColor: Color(0xFF0369A1),
          icon: Icons.description,
        );
      case RequestStatus.underReview:
        return const StatusBadge(
          label: 'Under Review',
          backgroundColor: Color(0xFFFEF3C7),
          textColor: Color(0xFFB45309),
          icon: Icons.find_in_page_rounded,
        );
      case RequestStatus.approved:
        return const StatusBadge(
          label: 'Approved',
          backgroundColor: Color(0xFFD1FAE5),
          textColor: Color(0xFF047857),
          icon: Icons.verified_user_rounded,
        );
      case RequestStatus.rejected:
        return const StatusBadge(
          label: 'Rejected',
          backgroundColor: Color(0xFFFEE2E2),
          textColor: Color(0xFFB91C1C),
          icon: Icons.cancel_rounded,
        );
      case RequestStatus.documentReady:
        return const StatusBadge(
          label: 'Document Ready',
          backgroundColor: Color(0xFFCCFBF1),
          textColor: Color(0xFF0F766E),
          icon: Icons.download_done_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
