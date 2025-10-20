var ContentExtractor = function() {};

ContentExtractor.prototype = {
  run: function(arguments) {
    const draftSpans = document.querySelectorAll('.highlighted-text[data-draft-id]');
    
    const drafts = Array.from(draftSpans).map(span => {
      return {
        id: span.dataset.draftId,
        sentence: span.textContent,
        type: span.dataset.highlightType,
        comments: JSON.parse(span.dataset.comments || '[]'),
        url: window.location.href,
        isDraft: true
      };
    });
    
    const result = {
      "title": document.title,
      "url": document.URL,
      "drafts": drafts
    };
    
    arguments.completionFunction(result);
  },
  
  finalize: function(arguments) {
    if (arguments.clearDrafts) {
      const draftSpans = document.querySelectorAll('.highlighted-text[data-draft-id]');
      draftSpans.forEach(span => {
        const capsuleContainer = span.nextElementSibling;
        if (capsuleContainer && capsuleContainer.classList.contains('capsule-container')) {
          capsuleContainer.remove();
        }
        span.replaceWith(...span.childNodes);
      });
      
      browser.storage.local.remove('draftHighlights').then(() => {
        console.log('Finalize: 초안 데이터가 삭제되었습니다.');
      });
    }
  }
};

var ExtensionPreprocessingJS = new ContentExtractor;

