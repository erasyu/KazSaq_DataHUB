import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kazsaq_datahub/providers/ai_provider.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:kazsaq_datahub/widgets/animated_card.dart';
import 'package:intl/intl.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppConstants.animationDuration,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.smart_toy, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'ИИ Помощник',
              style: AppTextStyles.h3,
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Consumer<AiProvider>(
            builder: (context, provider, child) {
              if (!provider.hasApiKey) {
                return IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => _showApiKeyDialog(context),
                );
              }
              return IconButton(
                icon: const Icon(Icons.clear_all),
                onPressed: () {
                  provider.clearMessages();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<AiProvider>(
        builder: (context, provider, child) {
          if (!provider.hasApiKey) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.smart_toy,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Настройте API ключ',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Для использования ИИ помощника необходимо добавить API ключ Groq',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _showApiKeyDialog(context),
                      icon: const Icon(Icons.settings),
                      label: const Text('Добавить API ключ'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: provider.messages.isEmpty
                    ? _buildEmptyState()
                    : _buildMessagesList(provider),
              ),
              _buildInputArea(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.smart_toy,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'ИИ Помощник',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 8),
            Text(
              'Задайте вопрос о университетах Казахстана',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildQuickQuestion('Какие университеты есть в Алматы?'),
                _buildQuickQuestion('Лучшие технические вузы'),
                _buildQuickQuestion('Программы по медицине'),
                _buildQuickQuestion('Стипендии для студентов'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickQuestion(String question) {
    return Consumer<AiProvider>(
      builder: (context, provider, child) {
        return ActionChip(
          label: Text(question),
          onPressed: () {
            provider.askQuestion(question);
            _scrollToBottom();
          },
          backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
        );
      },
    );
  }

  Widget _buildMessagesList(AiProvider provider) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: provider.messages.length,
      itemBuilder: (context, index) {
        final message = provider.messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(AiMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: AnimatedCard(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? AppColors.primary
                      : message.isError
                          ? AppColors.error.withValues(alpha: 0.1)
                          : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.text,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: message.isUser
                            ? Colors.white
                            : message.isError
                                ? AppColors.error
                                : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('HH:mm').format(message.timestamp),
                      style: AppTextStyles.caption.copyWith(
                        color: message.isUser
                            ? Colors.white70
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea(AiProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Задайте вопрос...',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.defaultBorderRadius),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty && !provider.isLoading) {
                    provider.askQuestion(value.trim());
                    _messageController.clear();
                    _scrollToBottom();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Consumer<AiProvider>(
              builder: (context, provider, child) {
                return FloatingActionButton(
                  onPressed: provider.isLoading ||
                          _messageController.text.trim().isEmpty
                      ? null
                      : () {
                          provider.askQuestion(_messageController.text.trim());
                          _messageController.clear();
                          _scrollToBottom();
                        },
                  backgroundColor: AppColors.primary,
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API ключ Groq'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Введите API ключ',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<AiProvider>().setApiKey(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}

