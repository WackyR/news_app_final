import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class Aisummary extends StatefulWidget {
  final Uri url;
  const Aisummary({
    super.key,
    required this.url,});

  @override
  State<Aisummary> createState() => _AisummaryState();
}

class _AisummaryState extends State<Aisummary> {
  final apiKey = 'AIzaSyBoJ7-gQJGxLxzgudfVuWLKy9MMHS_iJs0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _generateContent(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return _buildGeneratedContent(snapshot.data ?? 'No content generated');
            }
          },
        ),
      ),
    );
  }

  Future<String?> _generateContent() async {
  // Fetch article content from the URL
  final response = await http.get(widget.url);
  
  if (response.statusCode == 200) {
    String articleContent = response.body;
    
    // Now pass this content to the AI model for summarization
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
    
    final prompt = 'Summarize the following news article: $articleContent';
    
    final aiResponse = await model.generateContent([Content.text(prompt)]);
    print(aiResponse.text);
    return aiResponse.text;
  } else {
    throw Exception('Failed to load article content');
  }
}


  Widget _buildGeneratedContent(String content) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Generated Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
