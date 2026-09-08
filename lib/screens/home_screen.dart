import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Unread', 'Groups', 'Favorites'];

  int _currentNavIndex = 0;
  late final PageController _pageController;

  late List<ChatSummary> _allChats;
  List<ChatSummary> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentNavIndex);
    _allChats = ChatSummary.getSampleChats();
    _filteredChats = _allChats;

    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _applyFilter(int index) {
    setState(() {
      _selectedFilterIndex = index;
      final query = _searchController.text.trim().toLowerCase();

      _filteredChats = _allChats.where((chat) {
        // Tab filter
        bool matchesTab = true;
        if (index == 1) matchesTab = chat.unreadCount > 0;
        if (index == 2) matchesTab = chat.isGroup;
        if (index == 3) matchesTab = chat.isFavorite;

        // Query filter
        bool matchesQuery = true;
        if (query.isNotEmpty) {
          matchesQuery = chat.name.toLowerCase().contains(query) ||
              chat.lastMessage.toLowerCase().contains(query);
        }

        return matchesTab && matchesQuery;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _applyFilter(_selectedFilterIndex);
  }

  @override
  Widget build(BuildContext context) {
    final colors = PingMeThemeColors.of(context);
    final isDark = colors.isDark;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Area
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
                border: Border.all(color: colors.border, width: 1),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                          // User Avatar with Online Dot
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: isDark
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF29402A),
                                            Color(0xFF3A2945),
                                            Color(0xFF3F293B),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : AppColors.brandGradient,
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.darkSurface
                                        : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'TM',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colors.onlineDot,
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkSurface
                                          : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 240),
                                  switchInCurve: Curves.easeOutCubic,
                                  switchOutCurve: Curves.easeInCubic,
                                  layoutBuilder: (currentChild, previousChildren) {
                                    return Stack(
                                      alignment: Alignment.centerLeft,
                                      children: <Widget>[
                                        ...previousChildren,
                                        if (currentChild != null) currentChild,
                                      ],
                                    );
                                  },
                                  transitionBuilder: (child, animation) => FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.12),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  ),
                                  child: Text(
                                    _getHeaderTitle(),
                                    key: ValueKey<String>(_getHeaderTitle()),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: colors.textPrimary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 240),
                                  switchInCurve: Curves.easeOutCubic,
                                  switchOutCurve: Curves.easeInCubic,
                                  layoutBuilder: (currentChild, previousChildren) {
                                    return Stack(
                                      alignment: Alignment.centerLeft,
                                      children: <Widget>[
                                        ...previousChildren,
                                        if (currentChild != null) currentChild,
                                      ],
                                    );
                                  },
                                  transitionBuilder: (child, animation) => FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                  child: Text(
                                    _getHeaderSubtitle(),
                                    key: ValueKey<String>(_getHeaderSubtitle()),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Header Action Icons: One-Tap Theme Toggle & More
                      Row(
                        children: [
                          _buildThemeToggleButton(colors),
                          const SizedBox(width: 8),
                          _buildHeaderIconButton(
                            icon: Icons.more_horiz_rounded,
                            colors: colors,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Body: Tab-switched view (Chats, Connections, Updates, Calls)
            Expanded(
              child: _buildActiveTabBody(colors),
            ),
          ],
        ),
      ),

      // Footer Navigation Bar: Chats, Connections, Updates, Calls
      bottomNavigationBar: _buildBottomFooter(colors),

      // Floating Action Button: Add new people / chat at right corner above footer
      floatingActionButton: _currentNavIndex == 0 ? _buildNewChatFab(colors) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildThemeToggleButton(PingMeThemeColors colors) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, currentMode, _) {
        final isDark = currentMode == ThemeMode.dark;
        return InkWell(
          onTap: () {
            ThemeController.instance.toggleTheme();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.surfaceSecondary,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.darkFocusBorder : colors.border,
                width: 1,
              ),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey<bool>(isDark),
                  size: 18,
                  color: isDark ? const Color(0xFFE7C8F8) : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    required PingMeThemeColors colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: colors.surfaceSecondary,
          shape: BoxShape.circle,
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Icon(
          icon,
          size: 19,
          color: colors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildChatCard(ChatSummary chat, PingMeThemeColors colors) {
    final isDark = colors.isDark;
    final avatarBg = AppColors.adaptAvatarBg(chat.avatarBgColor, isDark);
    final avatarFg = AppColors.adaptAvatarFg(chat.avatarBgColor, isDark);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openChat(chat),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border, width: 1),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Row(
            children: [
              // Avatar with Presence Status
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: avatarBg,
                    ),
                    child: Center(
                      child: Text(
                        chat.avatarInitials,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: avatarFg,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: chat.isOnline
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

              const SizedBox(width: 14),

              // Name & Message Preview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            chat.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          chat.time,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: chat.unreadCount > 0
                                ? colors.onlineText
                                : colors.textPlaceholder,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.isTyping ? '● typing...' : chat.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: chat.unreadCount > 0
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: chat.isTyping
                                  ? colors.onlineText
                                  : (chat.unreadCount > 0
                                      ? colors.textPrimary
                                      : colors.textSecondary),
                              fontStyle: chat.isTyping
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                          ),
                        ),

                        // Unread Count Badge (Lime #B9E99F in Dark, #C8F0B0 in Light)
                        if (chat.unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: colors.greenAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${chat.unreadCount}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF111111),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(PingMeThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surfaceSecondary,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 28,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No conversations found',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try changing your filter or search query',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewChatFab(PingMeThemeColors colors) {
    final isDark = colors.isDark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 4),
      child: GestureDetector(
        onTap: () {
          if (_allChats.isNotEmpty) {
            _openChat(_allChats.first);
          }
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colors.ctaBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? AppColors.darkLavenderAccent.withValues(alpha: 0.38)
                    : Colors.black.withValues(alpha: 0.24),
                blurRadius: isDark ? 20 : 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.person_add_alt_1_rounded,
              color: colors.ctaForeground,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

  void _openChat(ChatSummary chat) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(chat: chat),
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_currentNavIndex) {
      case 1:
        return 'Updates';
      case 2:
        return 'Connections';
      case 3:
        return 'Calls';
      default:
        return 'Chats';
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentNavIndex) {
      case 1:
        return 'Status & Channels';
      case 2:
        return 'People & Contacts';
      case 3:
        return 'Recent Call Logs';
      default:
        return 'PingMe Network';
    }
  }

  // ═════════════════════════════════════════════════════════════════
  // Footer Tab Views & Navigation
  // ═════════════════════════════════════════════════════════════════

  Widget _buildActiveTabBody(PingMeThemeColors colors) {
    return PageView(
      controller: _pageController,
      physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
      onPageChanged: (index) {
        setState(() {
          _currentNavIndex = index;
        });
      },
      children: [
        _buildChatsTab(colors),
        _buildUpdatesTab(colors),
        _buildConnectionsTab(colors),
        _buildCallsTab(colors),
      ],
    );
  }

  /// Tab 0: Chats (Search + Filters + Chat List)
  Widget _buildChatsTab(PingMeThemeColors colors) {
    final isDark = colors.isDark;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 14),
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: colors.surfaceSecondary,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _searchFocusNode.hasFocus
                    ? colors.focusedBorder
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: isDark
                      ? const Color(0xFFAAAAAA)
                      : const Color(0xFF555555),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: _onSearchChanged,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search messages, contacts...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: colors.textPlaceholder,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Filter Pills (All, Unread, Groups, Favorites)
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(_filters.length, (index) {
                final isSelected = _selectedFilterIndex == index;
                final label = _filters[index];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => _applyFilter(index),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                ? AppColors.darkLavenderSurface
                                : AppColors.lavender)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? (isDark
                                  ? AppColors.darkFocusBorder
                                  : AppColors.lavender)
                              : colors.border,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? (isDark
                                      ? const Color(0xFFE7C8F8)
                                      : AppColors.textPrimary)
                                  : colors.textSecondary,
                            ),
                          ),
                          if (index == 1) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: colors.greenAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${_allChats.where((c) => c.unreadCount > 0).length}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF111111),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Chats Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Chats',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '${_filteredChats.length} Conversations',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Chat items list
        if (_filteredChats.isEmpty)
          _buildEmptyState(colors)
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: _filteredChats.map((chat) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildChatCard(chat, colors),
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 80), // Padding for floating CTA button
      ],
    );
  }

  /// Tab 1: Connections (Contact directory with quick ping & invite actions)
  Widget _buildConnectionsTab(PingMeThemeColors colors) {
    final isDark = colors.isDark;
    final contacts = _allChats;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        // Invite card / New connection banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkLavenderSurface : const Color(0xFFF4EBFC),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark ? AppColors.darkFocusBorder : AppColors.lavender,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.darkLavenderAccent : AppColors.ctaBlack,
                ),
                child: Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 20,
                  color: isDark ? const Color(0xFF111111) : Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite friends to PingMe',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Share your secret handle @tirth_m',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkLavenderAccent : AppColors.ctaBlack,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Share',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF111111) : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Text(
            'All Connections (${contacts.length})',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colors.textSecondary,
            ),
          ),
        ),

        const SizedBox(height: 6),

        ...contacts.map((contact) {
          final avatarBg = AppColors.adaptAvatarBg(contact.avatarBgColor, isDark);
          final avatarFg = AppColors.adaptAvatarFg(contact.avatarBgColor, isDark);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: avatarBg,
                    ),
                    child: Center(
                      child: Text(
                        contact.avatarInitials,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: avatarFg,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          contact.isOnline ? 'Online now' : 'Seen recently',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: contact.isOnline
                                ? colors.onlineText
                                : colors.textPlaceholder,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _openChat(contact),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.surfaceSecondary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 17,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  /// Tab 2: Updates (Status pings, stories, broadcast channels)
  Widget _buildUpdatesTab(PingMeThemeColors colors) {
    final isDark = colors.isDark;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        // My Status Row
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border, width: 1),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isDark
                          ? const LinearGradient(
                              colors: [Color(0xFF29402A), Color(0xFF3A2945)],
                            )
                          : AppColors.brandGradient,
                    ),
                    child: Center(
                      child: Text(
                        'TM',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.greenAccent,
                        border: Border.all(
                          color: isDark ? colors.surface : Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 12,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Status Update',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tap to share a story, thought, or photo',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Recent Stories',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colors.textSecondary,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Recent stories list
        ..._allChats.take(3).map((contact) {
          final avatarBg = AppColors.adaptAvatarBg(contact.avatarBgColor, isDark);
          final avatarFg = AppColors.adaptAvatarFg(contact.avatarBgColor, isDark);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.primaryAccent,
                        width: 2.2,
                      ),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: avatarBg,
                      ),
                      child: Center(
                        child: Text(
                          contact.avatarInitials,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: avatarFg,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${contact.time} ago',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.play_circle_outline_rounded,
                    color: colors.primaryAccent,
                    size: 24,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  /// Tab 3: Calls (Audio & Video log with quick callback)
  Widget _buildCallsTab(PingMeThemeColors colors) {
    final isDark = colors.isDark;

    final callRecords = [
      {'chat': _allChats[0], 'type': 'video', 'incoming': false, 'time': 'Today, 2:15 PM'},
      {'chat': _allChats[1], 'type': 'audio', 'incoming': true, 'time': 'Yesterday, 8:40 PM'},
      {'chat': _allChats[3], 'type': 'video', 'incoming': true, 'time': '2 days ago'},
    ];

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Text(
            'Recent Calls',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 8),

        ...callRecords.map((record) {
          final chat = record['chat'] as ChatSummary;
          final isVideo = record['type'] == 'video';
          final isIncoming = record['incoming'] as bool;
          final avatarBg = AppColors.adaptAvatarBg(chat.avatarBgColor, isDark);
          final avatarFg = AppColors.adaptAvatarFg(chat.avatarBgColor, isDark);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: avatarBg,
                    ),
                    child: Center(
                      child: Text(
                        chat.avatarInitials,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: avatarFg,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              isIncoming
                                  ? Icons.call_received_rounded
                                  : Icons.call_made_rounded,
                              size: 13,
                              color: isIncoming
                                  ? colors.onlineText
                                  : colors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              record['time'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: colors.surfaceSecondary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: Icon(
                        isVideo ? Icons.videocam_outlined : Icons.call_outlined,
                        size: 18,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  /// Bottom Footer Navigation Bar: Chats, Connections, Updates, Calls
  Widget _buildBottomFooter(PingMeThemeColors colors) {
    final isDark = colors.isDark;

    final navItems = [
      {
        'label': 'Chats',
        'icon': Icons.chat_bubble_rounded,
        'outlineIcon': Icons.chat_bubble_outline_rounded,
        'badge': _allChats.where((c) => c.unreadCount > 0).length,
      },
      {
        'label': 'Updates',
        'icon': Icons.circle_notifications_rounded,
        'outlineIcon': Icons.circle_notifications_outlined,
        'badge': 0,
      },
      {
        'label': 'Connections',
        'icon': Icons.people_alt_rounded,
        'outlineIcon': Icons.people_alt_outlined,
        'badge': 0,
      },
      {
        'label': 'Calls',
        'icon': Icons.call_rounded,
        'outlineIcon': Icons.call_outlined,
        'badge': 0,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: colors.border, width: 1),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
      ),
      padding: EdgeInsets.fromLTRB(
        8,
        8,
        8,
        MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom + 4
            : 10,
      ),
      child: Row(
        children: List.generate(navItems.length, (index) {
          final item = navItems[index];
          final isSelected = _currentNavIndex == index;
          final badgeCount = item['badge'] as int;

          return Expanded(
            child: InkWell(
              onTap: () {
                if (_pageController.hasClients) {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 380),
                    curve: Curves.easeOutCubic,
                  );
                } else {
                  setState(() {
                    _currentNavIndex = index;
                  });
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 52,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.darkLavenderSurface : const Color(0xFFF1E6FB))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          isSelected
                              ? (item['icon'] as IconData)
                              : (item['outlineIcon'] as IconData),
                          size: 21,
                          color: isSelected
                              ? (isDark ? AppColors.darkLavenderAccent : AppColors.textPrimary)
                              : colors.textSecondary,
                        ),
                        if (badgeCount > 0)
                          Positioned(
                            top: -3,
                            right: -7,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors.greenAccent,
                                border: Border.all(
                                  color: isDark ? colors.surface : Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Center(
                                child: Text(
                                  '$badgeCount',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF111111),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item['label'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? (isDark ? AppColors.darkLavenderAccent : AppColors.textPrimary)
                            : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
