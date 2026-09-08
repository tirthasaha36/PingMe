import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_model.dart';
import '../theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final ChatSummary chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;
  bool _showSendButton = false;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.chat.messages);

    _textController.addListener(() {
      final hasText = _textController.text.trim().isNotEmpty;
      if (hasText != _showSendButton) {
        setState(() {
          _showSendButton = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      time: DateTime.now(),
      sender: MessageSender.me,
      readStatus: ReadStatus.read,
    );

    setState(() {
      _messages.add(newMessage);
      _textController.clear();
      _showSendButton = false;
    });

    // Auto scroll down smoothly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleReaction(ChatMessage message, String emoji) {
    setState(() {
      final index = _messages.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        final current = _messages[index];
        final newReaction = current.reaction == emoji ? null : emoji;
        _messages[index] = ChatMessage(
          id: current.id,
          text: current.text,
          time: current.time,
          sender: current.sender,
          readStatus: current.readStatus,
          reaction: newReaction,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = PingMeThemeColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: _buildAppBar(colors),
      body: Column(
        children: [
          // Date / Security Pill Banner
          _buildTopBanner(colors),

          // Message Stream List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message, colors);
              },
            ),
          ),

          // Message Input Field
          _buildInputBar(colors),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(PingMeThemeColors colors) {
    final isDark = colors.isDark;

    return AppBar(
      backgroundColor: colors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: colors.textPrimary,
          size: 19,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.adaptAvatarBg(widget.chat.avatarBgColor, isDark),
                ),
                child: Center(
                  child: Text(
                    widget.chat.avatarInitials,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.adaptAvatarFg(widget.chat.avatarBgColor, isDark),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.chat.isOnline
                        ? colors.onlineDot
                        : colors.offline,
                    border: Border.all(
                      color: isDark ? colors.surface : Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.chat.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  widget.chat.isTyping
                      ? 'typing...'
                      : (widget.chat.isOnline ? 'Online' : 'Offline'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.chat.isTyping
                        ? colors.onlineText
                        : (widget.chat.isOnline
                            ? colors.onlineText
                            : colors.textPlaceholder),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        _buildCircleAction(Icons.call_outlined, colors, () {}),
        const SizedBox(width: 6),
        _buildCircleAction(Icons.videocam_outlined, colors, () {}),
        const SizedBox(width: 12),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: colors.border,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, PingMeThemeColors colors, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colors.surfaceSecondary,
          shape: BoxShape.circle,
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Icon(icon, size: 18, color: colors.textPrimary),
      ),
    );
  }

  Widget _buildTopBanner(PingMeThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Text(
          '🔒 End-to-end encrypted chat',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, PingMeThemeColors colors) {
    final isMe = message.sender == MessageSender.me;
    final isDark = colors.isDark;
    final timeStr =
        "${message.time.hour.toString().padLeft(2, '0')}:${message.time.minute.toString().padLeft(2, '0')}";

    // Target dark specifications:
    // Your bubble: #3A2945 (Dark Lavender), text: #F5F5F5
    // Their bubble: #202020 (Elevated Surface), text: #F5F5F5
    final bubbleColor = isMe ? colors.yourBubble : colors.theirBubble;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : (isMe ? AppColors.textPrimary : AppColors.textPrimary);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(right: 8, bottom: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.adaptAvatarBg(widget.chat.avatarBgColor, isDark),
                  ),
                  child: Center(
                    child: Text(
                      widget.chat.avatarInitials,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.adaptAvatarFg(widget.chat.avatarBgColor, isDark),
                      ),
                    ),
                  ),
                ),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.74,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 20),
                    ),
                    border: isDark
                        ? Border.all(
                            color: isMe ? const Color(0xFF4C3759) : colors.border,
                            width: 1,
                          )
                        : (isMe ? null : Border.all(color: colors.border, width: 1)),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Spacer(),
                          Text(
                            timeStr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFF999999)
                                  : (isMe
                                      ? AppColors.textSecondary
                                      : AppColors.textPlaceholder),
                            ),
                          ),
                          if (isMe) ...[
                            const SizedBox(width: 4),
                            _buildReadReceiptTicks(message.readStatus, colors),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Message Reaction & Quick Reaction Bar
          if (message.reaction != null) ...[
            Padding(
              padding: EdgeInsets.only(
                top: 4,
                left: isMe ? 0 : 36,
                right: isMe ? 4 : 0,
              ),
              child: GestureDetector(
                onTap: () => _toggleReaction(message, message.reaction!),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkLavenderSurface
                        : AppColors.lavender,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkFocusBorder
                          : Colors.white,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    message.reaction!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReadReceiptTicks(ReadStatus status, PingMeThemeColors colors) {
    final isDark = colors.isDark;
    switch (status) {
      case ReadStatus.sent:
        return Icon(
          Icons.check_rounded,
          size: 13,
          color: isDark ? AppColors.darkSentReceipt : const Color(0xFF999999),
        );
      case ReadStatus.delivered:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.done_all_rounded,
              size: 14,
              color: isDark ? AppColors.darkDeliveredReceipt : const Color(0xFF777777),
            ),
          ],
        );
      case ReadStatus.read:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.done_all_rounded,
              size: 14,
              color: colors.readReceipt,
            ),
          ],
        );
    }
  }

  Widget _buildInputBar(PingMeThemeColors colors) {
    final isDark = colors.isDark;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.border, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment Button '+'
          GestureDetector(
            onTap: () => _showAttachmentSheet(colors),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF292929) : const Color(0xFFF0F0EE),
                border: Border.all(color: colors.border, width: 1),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 22,
                color: isDark ? const Color(0xFFB5B5B5) : colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Message Input Box
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceSecondary,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? colors.border : Colors.transparent,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              constraints: const BoxConstraints(minHeight: 42, maxHeight: 120),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: colors.textPlaceholder,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      size: 20,
                      color: colors.textPlaceholder,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send / Mic Button: Bright Lavender #DDB9F2 in Dark Mode with #111111 Icon
          GestureDetector(
            onTap: _showSendButton ? _sendMessage : () {},
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.ctaBackground,
              ),
              child: Icon(
                _showSendButton ? Icons.arrow_upward_rounded : Icons.mic_rounded,
                size: 20,
                color: colors.ctaForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentSheet(PingMeThemeColors colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAttachmentMenu(context, colors),
    );
  }

  Widget _buildAttachmentMenu(BuildContext sheetContext, PingMeThemeColors colors) {
    final isDark = colors.isDark;

    // Dark specification:
    // Camera: #3A2945 circle, #DDB9F2 icon
    // Gallery: #3F293B circle, #E8B9DE icon
    // Document: #29402A circle, #B9E99F icon
    // Audio: #3F293B circle, #E8B9DE icon
    // Location: #3A2945 circle, #DDB9F2 icon
    // Contact: #29402A circle, #B9E99F icon
    final items = [
      {
        'title': 'Camera',
        'icon': Icons.camera_alt_rounded,
        'bg': isDark ? AppColors.darkLavenderSurface : AppColors.lavender,
        'fg': isDark ? AppColors.darkLavenderAccent : AppColors.textPrimary,
      },
      {
        'title': 'Gallery',
        'icon': Icons.photo_library_rounded,
        'bg': isDark ? AppColors.darkPinkSurface : AppColors.softPink,
        'fg': isDark ? AppColors.darkPinkAccent : AppColors.textPrimary,
      },
      {
        'title': 'Document',
        'icon': Icons.description_rounded,
        'bg': isDark ? AppColors.darkGreenSurface : AppColors.limeGreen,
        'fg': isDark ? AppColors.darkLime : AppColors.textPrimary,
      },
      {
        'title': 'Audio',
        'icon': Icons.headphones_rounded,
        'bg': isDark ? AppColors.darkPinkSurface : AppColors.softPink,
        'fg': isDark ? AppColors.darkPinkAccent : AppColors.textPrimary,
      },
      {
        'title': 'Location',
        'icon': Icons.location_on_rounded,
        'bg': isDark ? AppColors.darkLavenderSurface : AppColors.lavender,
        'fg': isDark ? AppColors.darkLavenderAccent : AppColors.textPrimary,
      },
      {
        'title': 'Contact',
        'icon': Icons.person_rounded,
        'bg': isDark ? AppColors.darkGreenSurface : AppColors.limeGreen,
        'fg': isDark ? AppColors.darkLime : AppColors.textPrimary,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevated : colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: colors.border, width: 1),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Share Content',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 22),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                onTap: () {
                  Navigator.of(sheetContext).pop();
                },
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item['bg'] as Color,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: item['fg'] as Color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
