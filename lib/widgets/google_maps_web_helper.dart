import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

void registerGoogleMapsIframe(String viewId, String url) {
  try {
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int id) {
        final iframe = html.IFrameElement()
          ..src = url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allowFullscreen = true
          ..allow = 'fullscreen';
        
        iframe.onError.listen((event) {
          print('Google Maps iframe error: $event');
        });
        
        iframe.onLoad.listen((event) {
          print('Google Maps iframe loaded successfully');
        });
        
        return iframe;
      },
    );
  } catch (e) {
    print('View $viewId already registered or error: $e');
  }
}

