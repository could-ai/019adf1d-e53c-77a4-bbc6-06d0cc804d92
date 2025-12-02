import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/chat_message.dart';

class AiTutorScreen extends StatefulWidget {
  const AiTutorScreen({super.key});

  @override
  State<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends State<AiTutorScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Add initial greeting
    _messages.add(
      ChatMessage(
        text: "Hello! I am your VMEDU-JEENEET AI Tutor powered by VEERESH. How can I help you with your JEE or NEET preparation today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: _getSimulatedResponse(text),
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  String _getSimulatedResponse(String input) {
    final lowerInput = input.toLowerCase();
    if (lowerInput.contains('physics')) {
      return "Physics is crucial for both JEE and NEET. For JEE, focus on Mechanics and Electrodynamics. For NEET, ensure your concepts in Optics and Modern Physics are strong. Would you like a practice problem?";
    } else if (lowerInput.contains('chemistry')) {
      return "Chemistry is high-scoring! Organic chemistry requires understanding mechanisms, while Physical chemistry needs practice with formulas. Inorganic chemistry is all about NCERT. What topic are you stuck on?";
    } else if (lowerInput.contains('math')) {
      return "Mathematics requires consistent practice. Calculus and Algebra carry high weightage in JEE. Don't forget Coordinate Geometry! Shall we solve a calculus problem?";
    } else if (lowerInput.contains('biology') || lowerInput.contains('neet')) {
      return "For NEET, Biology is 50% of the paper! Focus on Human Physiology, Genetics, and Ecology. NCERT is your bible here. Need help with a specific diagram or concept?";
    } else if (lowerInput.contains('jee')) {
      return "JEE Main & Advanced require deep conceptual clarity. I can help you with previous year questions, mock tests, or specific concept explanations. Where should we start?";
    }
    return "That's an interesting question. As your VMEDU-JEENEET AI Mentor, I can help you break this down. Could you provide more specific details about the problem or concept?";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length) {
                return const _TypingIndicator();
              }
              final message = _messages[index];
              return _ChatBubble(message: message);
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F38),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFF00E5FF)),
                onPressed: () {
                  // TODO: Implement image upload for doubt solving
                },
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ask a doubt...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF0A0E21),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onSubmitted: _handleSubmitted,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: const Color(0xFF00E5FF),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: () => _handleSubmitted(_textController.text),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF00E5FF).withOpacity(0.2) : const Color(0xFF1A1F38),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(0),
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(20),
          ),
          border: Border.all(
            color: isUser ? const Color(0xFF00E5FF).withOpacity(0.5) : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'VMEDU AI',
                  style: TextStyle(
                    color: const Color(0xFF00E5FF),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            Text(
              message.text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F38),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E5FF)),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Thinking...',
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
