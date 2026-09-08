import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum MessageSender { me, other }

enum ReadStatus { sent, delivered, read }

class ChatMessage {
  final String id;
  final String text;
  final DateTime time;
  final MessageSender sender;
  final ReadStatus readStatus;
  final String? reaction;

  ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.sender,
    this.readStatus = ReadStatus.read,
    this.reaction,
  });
}

class ChatSummary {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isTyping;
  final bool isGroup;
  final bool isFavorite;
  final Color avatarBgColor;
  final String avatarInitials;
  final List<ChatMessage> messages;

  ChatSummary({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isTyping = false,
    this.isGroup = false,
    this.isFavorite = false,
    required this.avatarBgColor,
    required this.avatarInitials,
    required this.messages,
  });

  static List<ChatSummary> getSampleChats() {
    final now = DateTime.now();

    return [
      ChatSummary(
        id: '1',
        name: 'Rahul Sharma',
        lastMessage: 'Hey, are you coming to the design review today?',
        time: '5m',
        unreadCount: 3,
        isOnline: true,
        isTyping: false,
        isFavorite: true,
        avatarBgColor: AppColors.limeGreen,
        avatarInitials: 'RS',
        messages: [
          ChatMessage(
            id: 'm1',
            text: 'Hey Tirth! Did you check out the new design system specs?',
            time: now.subtract(const Duration(minutes: 18)),
            sender: MessageSender.other,
          ),
          ChatMessage(
            id: 'm2',
            text: 'Yes! The soft pastel and white card aesthetic looks incredible.',
            time: now.subtract(const Duration(minutes: 12)),
            sender: MessageSender.me,
            readStatus: ReadStatus.read,
            reaction: '❤️',
          ),
          ChatMessage(
            id: 'm3',
            text: 'Hey, are you coming to the design review today?',
            time: now.subtract(const Duration(minutes: 5)),
            sender: MessageSender.other,
          ),
        ],
      ),
      ChatSummary(
        id: '2',
        name: 'Ananya Roy',
        lastMessage: 'typing...',
        time: '8m',
        unreadCount: 1,
        isOnline: true,
        isTyping: true,
        isFavorite: true,
        avatarBgColor: AppColors.lavender,
        avatarInitials: 'AR',
        messages: [
          ChatMessage(
            id: 'm21',
            text: 'I loved the lavender message bubbles!',
            time: now.subtract(const Duration(minutes: 25)),
            sender: MessageSender.other,
          ),
          ChatMessage(
            id: 'm22',
            text: 'Right? It feels so modern and comfortable on the eyes.',
            time: now.subtract(const Duration(minutes: 15)),
            sender: MessageSender.me,
            readStatus: ReadStatus.read,
            reaction: '👍',
          ),
        ],
      ),
      ChatSummary(
        id: '3',
        name: 'Product Design Squad',
        lastMessage: 'Adom: Let’s ship the new build this evening! 🚀',
        time: '24m',
        unreadCount: 5,
        isOnline: false,
        isGroup: true,
        isFavorite: false,
        avatarBgColor: AppColors.softPink,
        avatarInitials: 'PD',
        messages: [
          ChatMessage(
            id: 'm31',
            text: 'Let’s ship the new build this evening! 🚀',
            time: now.subtract(const Duration(minutes: 24)),
            sender: MessageSender.other,
          ),
        ],
      ),
      ChatSummary(
        id: '4',
        name: 'Devanshi Mehta',
        lastMessage: 'Sent you the Figma prototype link.',
        time: '1h',
        unreadCount: 0,
        isOnline: true,
        isTyping: false,
        avatarBgColor: AppColors.limeGreen,
        avatarInitials: 'DM',
        messages: [
          ChatMessage(
            id: 'm41',
            text: 'Sent you the Figma prototype link.',
            time: now.subtract(const Duration(hours: 1)),
            sender: MessageSender.other,
          ),
          ChatMessage(
            id: 'm42',
            text: 'Got it! Checking now.',
            time: now.subtract(const Duration(minutes: 45)),
            sender: MessageSender.me,
            readStatus: ReadStatus.delivered,
          ),
        ],
      ),
      ChatSummary(
        id: '5',
        name: 'Siddharth Rao',
        lastMessage: 'Awesome, talk to you tomorrow then.',
        time: 'Yesterday',
        unreadCount: 0,
        isOnline: false,
        avatarBgColor: AppColors.lavender,
        avatarInitials: 'SR',
        messages: [
          ChatMessage(
            id: 'm51',
            text: 'Awesome, talk to you tomorrow then.',
            time: now.subtract(const Duration(days: 1)),
            sender: MessageSender.other,
          ),
        ],
      ),
      ChatSummary(
        id: '6',
        name: 'Mobile Engineering',
        lastMessage: 'Vikram: All unit tests are green.',
        time: '2d ago',
        unreadCount: 0,
        isGroup: true,
        avatarBgColor: AppColors.surfaceSecondary,
        avatarInitials: 'ME',
        messages: [
          ChatMessage(
            id: 'm61',
            text: 'All unit tests are green.',
            time: now.subtract(const Duration(days: 2)),
            sender: MessageSender.other,
          ),
        ],
      ),
      ChatSummary(
        id: '7',
        name: 'Pooja Iyer',
        lastMessage: 'Can you share the updated color palette codes?',
        time: '32m',
        unreadCount: 2,
        isOnline: true,
        isFavorite: true,
        avatarBgColor: AppColors.softPink,
        avatarInitials: 'PI',
        messages: [
          ChatMessage(
            id: 'm71',
            text: 'Hey! The dark mode theme looks sleek 👌',
            time: now.subtract(const Duration(minutes: 40)),
            sender: MessageSender.other,
          ),
          ChatMessage(
            id: 'm72',
            text: 'Can you share the updated color palette codes?',
            time: now.subtract(const Duration(minutes: 32)),
            sender: MessageSender.other,
          ),
        ],
      ),
      ChatSummary(
        id: '8',
        name: 'Design Explorers',
        lastMessage: 'Elena: Take a look at these micro-interactions ✨',
        time: '1h',
        unreadCount: 4,
        isGroup: true,
        avatarBgColor: AppColors.lavender,
        avatarInitials: 'DE',
        messages: [
          ChatMessage(
            id: 'm81',
            text: 'Take a look at these micro-interactions ✨',
            time: now.subtract(const Duration(hours: 1)),
            sender: MessageSender.other,
          ),
        ],
      ),
      ChatSummary(
        id: '9',
        name: 'Aarav Patel',
        lastMessage: 'Let’s catch up over coffee this Saturday!',
        time: '2h',
        unreadCount: 0,
        isOnline: false,
        avatarBgColor: AppColors.limeGreen,
        avatarInitials: 'AP',
        messages: [
          ChatMessage(
            id: 'm91',
            text: 'Let’s catch up over coffee this Saturday!',
            time: now.subtract(const Duration(hours: 2)),
            sender: MessageSender.other,
          ),
          ChatMessage(
            id: 'm92',
            text: 'Sounds great, let me know the place.',
            time: now.subtract(const Duration(hours: 1, minutes: 50)),
            sender: MessageSender.me,
            readStatus: ReadStatus.read,
          ),
        ],
      ),
      ChatSummary(
        id: '10',
        name: 'Kavya Nair',
        lastMessage: 'The animation curve feels super smooth now.',
        time: '4h',
        unreadCount: 0,
        isOnline: true,
        avatarBgColor: AppColors.lavender,
        avatarInitials: 'KN',
        messages: [
          ChatMessage(
            id: 'm101',
            text: 'The animation curve feels super smooth now.',
            time: now.subtract(const Duration(hours: 4)),
            sender: MessageSender.other,
          ),
        ],
      ),
      ChatSummary(
        id: '11',
        name: 'Frontend Guild',
        lastMessage: 'Rohan: Flutter 3.x performance benchmarks are up!',
        time: '6h',
        unreadCount: 7,
        isGroup: true,
        isFavorite: true,
        avatarBgColor: AppColors.limeGreen,
        avatarInitials: 'FG',
        messages: [
          ChatMessage(
            id: 'm111',
            text: 'Flutter 3.x performance benchmarks are up!',
            time: now.subtract(const Duration(hours: 6)),
            sender: MessageSender.other,
          ),
        ],
      ),
      ChatSummary(
        id: '12',
        name: 'Zara Chen',
        lastMessage: 'Shared a file: pingme_brand_assets.zip',
        time: 'Yesterday',
        unreadCount: 0,
        isOnline: false,
        avatarBgColor: AppColors.softPink,
        avatarInitials: 'ZC',
        messages: [
          ChatMessage(
            id: 'm121',
            text: 'Shared a file: pingme_brand_assets.zip',
            time: now.subtract(const Duration(days: 1)),
            sender: MessageSender.other,
          ),
        ],
      ),
      ChatSummary(
        id: '13',
        name: 'Tanmay Joshi',
        lastMessage: 'Call me when you are free.',
        time: 'Yesterday',
        unreadCount: 1,
        isOnline: true,
        avatarBgColor: AppColors.surfaceSecondary,
        avatarInitials: 'TJ',
        messages: [
          ChatMessage(
            id: 'm131',
            text: 'Call me when you are free.',
            time: now.subtract(const Duration(days: 1, hours: 2)),
            sender: MessageSender.other,
          ),
        ],
      ),
      ChatSummary(
        id: '14',
        name: 'Startup Weekend',
        lastMessage: 'Meera: Don’t forget to submit the pitch deck.',
        time: '2d ago',
        unreadCount: 0,
        isGroup: true,
        avatarBgColor: AppColors.lavender,
        avatarInitials: 'SW',
        messages: [
          ChatMessage(
            id: 'm141',
            text: 'Don’t forget to submit the pitch deck.',
            time: now.subtract(const Duration(days: 2)),
            sender: MessageSender.other,
          ),
        ],
      ),
      ChatSummary(
        id: '15',
        name: 'Ishaan Verma',
        lastMessage: 'Thanks for the quick review! 🙏',
        time: '3d ago',
        unreadCount: 0,
        isOnline: false,
        isFavorite: false,
        avatarBgColor: AppColors.limeGreen,
        avatarInitials: 'IV',
        messages: [
          ChatMessage(
            id: 'm151',
            text: 'Thanks for the quick review! 🙏',
            time: now.subtract(const Duration(days: 3)),
            sender: MessageSender.other,
          ),
        ],
      ),
      ChatSummary(
        id: '16',
        name: 'Sneha Kapoor',
        lastMessage: 'See you at the conference next week!',
        time: '4d ago',
        unreadCount: 0,
        isOnline: false,
        avatarBgColor: AppColors.softPink,
        avatarInitials: 'SK',
        messages: [
          ChatMessage(
            id: 'm161',
            text: 'See you at the conference next week!',
            time: now.subtract(const Duration(days: 4)),
            sender: MessageSender.other,
          ),
        ],
      ),
    ];
  }
}
