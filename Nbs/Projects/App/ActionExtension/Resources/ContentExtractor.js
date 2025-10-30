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
      "drafts": drafts,
      "imageURL": this.extractThumbnailImage()
    };
    
    arguments.completionFunction(result);
  },
  
  extractThumbnailImage: function() {
    let imageURL = null;

    let ogImage = document.querySelector('meta[property="og:image"]');
    if (ogImage && ogImage.content) {
      imageURL = ogImage.content;
    }

    if (!imageURL) {
      let twitterImage = document.querySelector('meta[name="twitter:image"]');
      if (twitterImage && twitterImage.content) {
        imageURL = twitterImage.content;
      }
    }
    
    if (!imageURL) {
      let appleIcon = document.querySelector('link[rel="apple-touch-icon"]');
      if (appleIcon && appleIcon.href) {
        imageURL = appleIcon.href;
      }
    }

    if (!imageURL) {
      let favicon = document.querySelector('link[rel="icon"]');
      if (favicon && favicon.href) {
        imageURL = favicon.href;
      }
    }

    if (!imageURL) {
      let images = Array.from(document.querySelectorAll('img'));
      if (images.length > 0) {
        images.sort((a, b) => (b.naturalWidth * b.naturalHeight) - (a.naturalWidth * a.naturalHeight));
        if (images[0].src) {
          imageURL = images[0].src;
        }
      }
    }

    return imageURL;
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

