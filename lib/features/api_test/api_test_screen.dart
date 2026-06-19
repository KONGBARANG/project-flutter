import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../services/mock_api.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final _urlC = TextEditingController(text: 'https://jsonplaceholder.typicode.com/posts/1');
  String? _result;
  String? _error;
  int? _statusCode;
  Map<String, String>? _responseHeaders;
  String? _rawBody;
  bool _showRaw = false;
  bool _loading = false;

  @override
  void dispose() {
    _urlC.dispose();
    super.dispose();
  }

  Future<void> _callApi() async {
    final url = _urlC.text.trim();
    if (url.isEmpty) return;
    setState(() {
      _loading = true;
      _result = null;
      _error = null;
    });

    try {
      final uri = Uri.parse(url);
      final res = await http.get(uri).timeout(const Duration(seconds: 12));
      _statusCode = res.statusCode;
      _responseHeaders = res.headers.map((k, v) => MapEntry(k, v.toString()));
      _rawBody = res.body;

      if (res.statusCode >= 200 && res.statusCode < 300) {
        // Try to pretty-print JSON, fallback to raw body
        try {
          final decoded = json.decode(res.body);
          final pretty = const JsonEncoder.withIndent('  ').convert(decoded);
          setState(() => _result = pretty);
        } catch (_) {
          setState(() => _result = res.body);
        }
      } else {
        setState(() => _error = 'HTTP ${res.statusCode}: ${res.reasonPhrase ?? ''}');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Request', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _urlC,
                      decoration: const InputDecoration(
                        labelText: 'URL',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                      onSubmitted: (_) => _callApi(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send),
                            label: const Text('Send'),
                            onPressed: _loading ? null : _callApi,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 44),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: _loading
                              ? null
                              : () {
                                  setState(() {
                                    _result = null;
                                    _error = null;
                                    _statusCode = null;
                                    _responseHeaders = null;
                                    _rawBody = null;
                                  });
                                },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _loading
                                ? null
                                : () async {
                                    setState(() {
                                      _loading = true;
                                      _error = null;
                                    });
                                    try {
                                      final products = await MockApiService.getProducts();
                                      final pretty = const JsonEncoder.withIndent('  ').convert({'products': products});
                                      setState(() {
                                        _result = pretty;
                                        _statusCode = 200;
                                        _responseHeaders = {'source': 'local-mock'};
                                        _rawBody = pretty;
                                      });
                                    } catch (e) {
                                      setState(() => _error = e.toString());
                                    } finally {
                                      if (mounted) setState(() => _loading = false);
                                    }
                                  },
                            icon: const Icon(Icons.storage),
                            label: const Text('Load Local Products'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Response', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                                : _error != null
                                    ? SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Error: $_error', style: const TextStyle(color: Colors.red)),
                                            const SizedBox(height: 8),
                                            if (_statusCode != null) Text('Status: $_statusCode'),
                                            if (_rawBody != null) ...[
                                              const SizedBox(height: 8),
                                              const Text('Raw body:'),
                                              SelectableText(_rawBody!),
                                            ],
                                          ],
                                        ),
                                      )
                                    : _result != null || _rawBody != null
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              if (_statusCode != null) Text('Status: $_statusCode', style: const TextStyle(fontWeight: FontWeight.w600)),
                                              const SizedBox(height: 8),
                                              if (_responseHeaders != null) ExpansionTile(
                                                title: const Text('Response Headers'),
                                                children: _responseHeaders!.entries.map((e) => ListTile(title: Text(e.key), subtitle: Text(e.value))).toList(),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () => setState(() => _showRaw = false),
                                                      child: const Text('Pretty'),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () => setState(() => _showRaw = true),
                                                      child: const Text('Raw'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: SelectableText(_showRaw ? (_rawBody ?? '') : (_result ?? _rawBody ?? '')),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton.icon(
                                                      onPressed: () async {
                                                        final textToCopy = _showRaw ? (_rawBody ?? '') : (_result ?? _rawBody ?? '');
                                                        await Clipboard.setData(ClipboardData(text: textToCopy));
                                                        if (!mounted) return;
                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied response')));
                                                      },
                                                      icon: const Icon(Icons.copy),
                                                      label: const Text('Copy'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : const Center(child: Text('No response yet.')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
