let lastSelectedHighlightType = 'what';
const isDark = window.matchMedia('(prefers-color-scheme: dark)').matche;

function getFixedHeaderHeight() {
  let fixedHeaderHeight = 0;
  const elements = document.querySelectorAll('body *');
  for (const el of elements) {
    const style = window.getComputedStyle(el);
    if (style.position === 'fixed' && el.offsetHeight > 0) {
      const rect = el.getBoundingClientRect();
      if (rect.top >= 0 && rect.top < 50) {
        fixedHeaderHeight = Math.max(fixedHeaderHeight, rect.bottom);
      }
    }
  }
  return fixedHeaderHeight;
}

function renderCapsules(span) {
  if (span.nextElementSibling && span.nextElementSibling.classList.contains('capsule-container')) {
    span.nextElementSibling.remove();
  }
  
  const comments = JSON.parse(span.dataset.comments || '[]');
  
  if (comments.length > 0) {
    const container = document.createElement('div');
    container.className = 'capsule-container';
    span.after(container);
    
    comments.forEach(comment => {
      const capsule = document.createElement('div');
      capsule.className = 'memo-capsule';
      capsule.dataset.memoType = comment.type;
      
      const textPreview = document.createElement('span');
      textPreview.className = 'capsule-text';
      textPreview.textContent = comment.text;
      
      const deleteBtn = document.createElement('button');
      deleteBtn.className = 'capsule-delete-btn';
      const svgContainer = document.createElement('div');
      svgContainer.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="none" viewBox="0 0 32 32"><path stroke="#71717a" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.25" d="M21 11 11 21M11 11l10 10"/></svg>';
      deleteBtn.appendChild(svgContainer.firstChild);
      
      capsule.appendChild(textPreview);
      capsule.appendChild(deleteBtn);
      
      capsule.addEventListener('click', (e) => {
        e.stopPropagation();
        
        const tulipMenu = document.getElementById('tulip-menu');
        if (tulipMenu) {
          tulipMenu.remove();
        }
        
        const isAlreadyClicked = capsule.classList.contains(`clicked-${comment.type}`);
        const memoBoxOpenForThisCapsule = document.getElementById('memo-box') && Number(document.getElementById('memo-box').dataset.editingId) === comment.id;
        
        document.querySelectorAll('.memo-capsule.clicked-what, .memo-capsule.clicked-why, .memo-capsule.clicked-detail').forEach(c => {
          c.classList.remove('clicked-what', 'clicked-why', 'clicked-detail');
        });
        
        if (isAlreadyClicked && memoBoxOpenForThisCapsule) {
          closeMemoBox();
          return;
        }
        
        capsule.classList.add(`clicked-${comment.type}`);
        showMemoBox(span, comment.id);
      });
      
      deleteBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        const memoBox = document.getElementById('memo-box');
        if (memoBox && Number(memoBox.dataset.editingId) === comment.id) {
          memoBox.remove();
        }
        const updatedComments = JSON.parse(span.dataset.comments || '[]').filter(m => m.id !== comment.id);
        span.dataset.comments = JSON.stringify(updatedComments);
        renderCapsules(span);
      });
      
      container.appendChild(capsule);
    });
  }
}

function closeMemoBox() {
    const memoBox = document.getElementById('memo-box');
    if (!memoBox) return;

    const span = document.querySelector(`[data-id="${memoBox.dataset.highlightId}"]`);
    if (!span) return;

    const textarea = memoBox.querySelector('textarea');
    const commentText = textarea.value.trim();
    let updatedComments = JSON.parse(span.dataset.comments || '[]');
    const memoId = Number(memoBox.dataset.editingId);

    if (memoId) {
        const commentIndex = updatedComments.findIndex(m => m.id === memoId);
        if (commentIndex > -1) {
            if (commentText) {
                updatedComments[commentIndex].text = commentText;
            } else {
                updatedComments.splice(commentIndex, 1);
            }
        }
    } else {
        if (commentText) {
            const newComment = {
                id: Date.now(),
                type: span.dataset.highlightType,
                text: commentText
            };
            updatedComments.push(newComment);
        }
    }

    span.dataset.comments = JSON.stringify(updatedComments);
    memoBox.remove();
    renderCapsules(span);

    document.querySelectorAll('.memo-capsule.clicked-what, .memo-capsule.clicked-why, .memo-capsule.clicked-detail').forEach(c => {
        c.classList.remove('clicked-what', 'clicked-why', 'clicked-detail');
    });
}

function showMemoBox(span, memoId = null) {
  closeMemoBox();

  const comments = JSON.parse(span.dataset.comments || '[]');
  const currentComment = memoId ? comments.find(m => m.id === memoId) : null;
  
  const memoBox = document.createElement('div');
  memoBox.id = 'memo-box';
  memoBox.dataset.highlightId = span.dataset.id;
  if (memoId) {
    memoBox.dataset.editingId = memoId;
  }
  memoBox.addEventListener('click', e => e.stopPropagation());
  
  const currentHighlightType = currentComment ? currentComment.type : span.dataset.highlightType;
  const existingText = currentComment ? currentComment.text : '';
  
  const textarea = document.createElement('textarea');
  textarea.placeholder = '중요한 내용이나 생각을 입력해보세요';
  textarea.value = existingText;
  memoBox.appendChild(textarea);
  
  textarea.addEventListener('blur', closeMemoBox);
  
  span.after(memoBox);
  textarea.focus();
}

function showTulipMenu(span) {
  if (document.getElementById('memo-box')) return;
  const existingMenu = document.getElementById('tulip-menu');
  if (existingMenu) existingMenu.remove();
  
  const menu = document.createElement('div');
  menu.id = 'tulip-menu';
  menu.addEventListener('click', e => e.stopPropagation());
  
  const buttons = [
    { text: '', type: 'what' },
    { text: '', type: 'why' },
    { text: '', type: 'detail' },
    { text: '', type: 'memo' }
  ];
  
  buttons.forEach(buttonInfo => {
    const button = document.createElement('button');
    if (buttonInfo.type === 'memo') {
      if (isDark) {
        button.innerHTML = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" clip-rule="evenodd" d="M12.328 7.02367L5.54608 13.8056L4.62106 17.2557L4.01261 19.5286C3.99571 19.5921 3.9958 19.6589 4.01286 19.7224C4.02992 19.7859 4.06336 19.8437 4.10982 19.8902C4.15628 19.9366 4.21414 19.9701 4.2776 19.9871C4.34105 20.0042 4.40788 20.0043 4.47138 19.9874L6.74276 19.3782L10.1936 18.4532H10.1944L16.9763 11.6712L12.3288 7.02367H12.328ZM19.7806 7.80949L16.1913 4.21943C16.1218 4.14987 16.0393 4.09469 15.9486 4.05703C15.8578 4.01938 15.7604 4 15.6621 4C15.5639 4 15.4665 4.01938 15.3757 4.05703C15.2849 4.09469 15.2025 4.14987 15.133 4.21943L13.2807 6.07096L17.929 10.7193L19.7806 8.86697C19.8501 8.79753 19.9053 8.71505 19.943 8.62426C19.9806 8.53347 20 8.43614 20 8.33785C20 8.23956 19.9806 8.14224 19.943 8.05145C19.9053 7.96066 19.8501 7.87818 19.7806 7.80874" fill="#B9B9C0"/>
        </svg>`;
      } else {
        button.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path fill="#5c5c6e" fill-rule="evenodd" d="m12.328 7.024-6.782 6.782-.925 3.45-.608 2.273a.375.375 0 0 0 .458.458l2.272-.609 3.45-.925h.001l6.782-6.782zm7.453.785-3.59-3.59a.75.75 0 0 0-1.058 0l-1.852 1.852 4.648 4.648 1.852-1.852a.75.75 0 0 0 0-1.058" clip-rule="evenodd"/></svg>`;
      }
    } else {
      button.textContent = buttonInfo.text;
    }
    
    button.dataset.highlightType = buttonInfo.type;
    
    if (buttonInfo.type === span.dataset.highlightType) {
      button.classList.add('selected');
    }
    
    button.addEventListener('click', (event) => {
      event.stopPropagation();
      if (buttonInfo.type === 'memo') {
        menu.remove();
        showMemoBox(span, null);
      } else {
        const newType = buttonInfo.type;
        span.dataset.highlightType = newType;
        let comments = JSON.parse(span.dataset.comments || '[]');
        if (comments.length > 0) {
          comments.forEach(comment => comment.type = newType);
          span.dataset.comments = JSON.stringify(comments);
          renderCapsules(span);
        }
        menu.querySelectorAll('button').forEach(btn => btn.classList.remove('selected'));
        button.classList.add('selected');
        lastSelectedHighlightType = newType;
      }
    });
    menu.appendChild(button);
  });
  
  document.body.appendChild(menu);
  
  const spanRect = span.getBoundingClientRect();
  const menuRect = menu.getBoundingClientRect();
  const fixedHeaderHeight = getFixedHeaderHeight();

  const spaceAvailableAbove = spanRect.top - fixedHeaderHeight;
  if (menuRect.height + 10 > spaceAvailableAbove) {
      const scrollAmount = menuRect.height + 10 - spaceAvailableAbove;
      //window.scrollBy({ top: -scrollAmount, behavior: 'instant' });
  }

  const newSpanRect = span.getBoundingClientRect();
  const newMenuRect = menu.getBoundingClientRect();

  let left = window.scrollX + newSpanRect.left + (newSpanRect.width / 2) - (newMenuRect.width / 2);
  if (left < window.scrollX) left = window.scrollX + 10;
  if (left + newMenuRect.width > window.scrollX + window.innerWidth)
      left = window.scrollX + window.innerWidth - newMenuRect.width - 10;

  let top = window.scrollY + newSpanRect.top - newMenuRect.height - 14;

  menu.style.left = `${left}px`;
  menu.style.top = `${top}px`;
}

function isInsideQuotes(text, index) {
  const quoteChars = ['"', "'", '“', '”', '‘', '’'];
  let count = 0;
  for (let i = 0; i < index; i++) {
    if (quoteChars.includes(text[i])) count++;
  }
  return count % 2 === 1;
}

function showDeleteConfirmationModal(onConfirm) {
  const existingModal = document.getElementById('delete-confirm-modal');
  if (existingModal) {
    existingModal.remove();
  }

  const modalContainer = document.createElement('div');
  modalContainer.id = 'delete-confirm-modal';

  const modalContent = document.createElement('div');
  modalContent.className = 'modal-content';
  
  modalContent.addEventListener('click', e => e.stopPropagation());

  const title = document.createElement('h3');
  title.textContent = '해당 하이라이트를 삭제할까요?';
  
  const message = document.createElement('p');
  message.textContent = '메모도 함께 삭제되며,\n삭제한 하이라이트는 복구할 수 없어요';
  message.style.whiteSpace = 'pre-line';

  const separator = document.createElement('div');
  separator.className = 'modal-separator';

  const buttonContainer = document.createElement('div');
  buttonContainer.className = 'modal-buttons';

  const cancelButton = document.createElement('button');
  cancelButton.textContent = '취소';
  cancelButton.onclick = () => {
    modalContainer.remove();
  };

  const verticalSeparator = document.createElement('div');
  verticalSeparator.className = 'vertical-separator';

  const confirmButton = document.createElement('button');
  confirmButton.className = 'delete-btn';
  confirmButton.textContent = '삭제';
  confirmButton.onclick = () => {
    onConfirm();
    modalContainer.remove();
  };

  buttonContainer.appendChild(cancelButton);
  buttonContainer.appendChild(verticalSeparator);
  buttonContainer.appendChild(confirmButton);

  modalContent.appendChild(title);
  modalContent.appendChild(message);
  modalContent.appendChild(separator);
  modalContent.appendChild(buttonContainer);
  
  modalContainer.appendChild(modalContent);

  modalContainer.addEventListener('click', () => {
    modalContainer.remove();
  });

  document.body.appendChild(modalContainer);
}

document.addEventListener('dblclick', function(event) {
  if (event.target.closest('.memo-capsule') || event.target.closest('#tulip-menu') || event.target.closest('#memo-box') || event.target.closest('#delete-confirm-modal')) {
    event.preventDefault();
    event.stopPropagation();
    return;
  }
  
  const existingHighlight = event.target.closest('.highlighted-text');
  if (existingHighlight) {
    event.preventDefault();
    event.stopPropagation();
    const comments = JSON.parse(existingHighlight.dataset.comments || '[]');
    const deleteHighlight = () => {
      const existingMenu = document.getElementById('tulip-menu');
      if (existingMenu) existingMenu.remove();
      const existingMemoBox = document.getElementById('memo-box');
      if (existingMemoBox) existingMemoBox.remove();
      const capsuleContainer = existingHighlight.nextElementSibling;
      if (capsuleContainer && capsuleContainer.classList.contains('capsule-container')) capsuleContainer.remove();
      existingHighlight.replaceWith(...existingHighlight.childNodes);
    };
    if (comments.length > 0) {
        showDeleteConfirmationModal(deleteHighlight);
    } else {
        deleteHighlight();
    }
    return;
  }
  
  const selection = window.getSelection();
  if (!selection.rangeCount) return;
  const range = selection.getRangeAt(0);
  const clickedElement = range.commonAncestorContainer;
  let textNode = clickedElement;
  if (textNode.nodeType !== Node.TEXT_NODE) {
    const treeWalker = document.createTreeWalker(clickedElement, NodeFilter.SHOW_TEXT);
    let currentNode;
    while (currentNode = treeWalker.nextNode()) {
      const nodeRange = document.createRange();
      nodeRange.selectNodeContents(currentNode);
      if (range.intersectsNode(nodeRange)) {
        textNode = currentNode;
        break;
      }
    }
    if (textNode.nodeType !== Node.TEXT_NODE) return;
  }
  
//  const text = textNode.textContent;
//  const clickPosition = range.startOffset;
  const { fullText, map } = buildUnifiedText(textNode);
  
  const text = fullText;
   let clickIndex = 0;
   for (const m of map) {
     if (m.node === textNode) {
       clickIndex = m.start + range.startOffset;
       break;
     }
   }
  
  const clickPosition = clickIndex;
  
  /// 문장 시작 탐색
  let sentenceStart = 0;
  for (let i = clickPosition - 1; i >= 0; i--) {
    const char = text[i];
    if ('.!?'.includes(char)) {
      if (char === '.' && /\d/.test(text[i - 1]) && /\d/.test(text[i + 1])) continue;
      if (char === '.' && i > 0 && /[A-Z]/.test(text[i - 1]) && (i === 1 || text[i - 2] === ' ')) continue;
      if (isInsideQuotes(text, i)) continue;
      sentenceStart = i + 1;
      if (i + 1 < text.length && /\s/.test(text[i + 1])) sentenceStart++;
      break;
    }
  }
  
  /// 문장 끝 탐색
  let sentenceEnd = text.length;
  for (let i = clickPosition; i < text.length; i++) {
    const char = text[i];
    if ('.!?'.includes(char)) {
      if (char === '.' && /\d/.test(text[i - 1]) && /\d/.test(text[i + 1])) continue;
      if (char === '.' && i > 0 && /[A-Z]/.test(text[i - 1]) && (i === 1 || text[i - 2] === ' ')) continue;
      if (isInsideQuotes(text, i)) continue;
      sentenceEnd = i + 1;
      break;
    }
  }
  
  /// range 생성 (노드 매핑 기반)
  const sentenceRange = document.createRange();
//  sentenceRange.setStart(textNode, sentenceStart);
//  sentenceRange.setEnd(textNode, sentenceEnd);
  for (const m of map) {
    if (sentenceStart >= m.start && sentenceStart <= m.end) {
      sentenceRange.setStart(m.node, sentenceStart - m.start);
      break;
    }
  }

  /// 문장 끝 설정
  for (const m of map) {
    if (sentenceEnd >= m.start && sentenceEnd <= m.end) {
      sentenceRange.setEnd(m.node, sentenceEnd - m.start);
      break;
    }
  }
  
  let extractedText = sentenceRange.toString();
  const leadingWhitespaceLength = extractedText.length - extractedText.trimStart().length;
  
  if (leadingWhitespaceLength > 0) {
//    sentenceRange.setStart(textNode, sentenceStart + leadingWhitespaceLength);
    const newSentenceStart = sentenceStart + leadingWhitespaceLength;
    for (const m of map) {
      if (newSentenceStart >= m.start && newSentenceStart <= m.end) {
        sentenceRange.setStart(m.node, newSentenceStart - m.start);
        break;
      }
    }
  }

  /// 최소 길이 제한
  if (sentenceRange.toString().trim().length < 3) return;
  
  /// 기존 하이라이트 충돌 체크
  const allHighlights = document.querySelectorAll('.highlighted-text');
  for (const highlight of allHighlights) {
    const highlightRange = document.createRange();
    highlightRange.selectNodeContents(highlight);
    if (sentenceRange.compareBoundaryPoints(Range.END_TO_START, highlightRange) < 0 &&
        sentenceRange.compareBoundaryPoints(Range.START_TO_END, highlightRange) > 0) return;
  }
  
  /// 최종 하이라이트 생성
  const span = document.createElement('span');
  span.className = 'highlighted-text';
  span.dataset.highlightType = lastSelectedHighlightType;
  span.dataset.id = `new-${Date.now()}`;
  
  try {
    span.appendChild(sentenceRange.extractContents());
    sentenceRange.insertNode(span);
    showTulipMenu(span);
  } catch (e) {
    console.error("하이라이트 적용 중 오류 발생:", e);
  }
});

function applyHighlights(highlights) {
    if (!highlights || highlights.length === 0) return;

    const matches = [];
    const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
    let node;

    while (node = walker.nextNode()) {
        for (const highlight of highlights) {
            if (!highlight.sentence) continue;
            const index = node.textContent.indexOf(highlight.sentence);
            if (index !== -1) {
                const range = document.createRange();
                range.setStart(node, index);
                range.setEnd(node, index + highlight.sentence.length);
                matches.push({ range: range, highlight: highlight });
            }
        }
    }

    matches.reverse().forEach(match => {
        const span = document.createElement('span');
        span.className = 'highlighted-text';
        span.dataset.highlightType = match.highlight.type;
        span.dataset.id = match.highlight.id;
        span.dataset.comments = JSON.stringify(match.highlight.comments || []);
        
        try {
            match.range.surroundContents(span);
            renderCapsules(span);
        } catch (e) {
            console.error("하이라이트 적용 중 오류 발생:", e);
        }
    });
}

document.addEventListener('click', function(event) {
    const tulipMenu = document.getElementById('tulip-menu');
    const memoBox = document.getElementById('memo-box');
    const clickedHighlight = event.target.closest('.highlighted-text');

    if (memoBox && !memoBox.contains(event.target) && !event.target.closest('.memo-capsule')) {
        closeMemoBox();
    }

    if (clickedHighlight) {
        showTulipMenu(clickedHighlight);
        return;
    }

    if (tulipMenu) {
        tulipMenu.remove();
    }
});

function getAllHighlightsData() {
  const highlights = document.querySelectorAll('.highlighted-text');
  const highlightsData = [];
  highlights.forEach(span => {
    const comments = JSON.parse(span.dataset.comments || '[]');
    highlightsData.push({
      id: span.dataset.id,
      sentence: span.textContent.trim(),
      type: span.dataset.highlightType,
      comments: comments
    });
  });
  
  if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.editHandler) {
    window.webkit.messageHandlers.editHandler.postMessage(highlightsData);
  } else {
    console.error("WebKit message handler 'editHandler' not found.");
  }
}

function buildUnifiedText(clickedNode) {
  let container = clickedNode;

  while (container && container !== document.body) {
    if (container.matches?.('span.article_p, p, div')) break;
    container = container.parentNode;
  }
  if (!container) container = document.body;

  const textNodes = [];
  const walker = document.createTreeWalker(container, NodeFilter.SHOW_TEXT);
  let node;
  while (node = walker.nextNode()) {
    if (node.textContent.trim().length > 0) textNodes.push(node);
  }

  let fullText = '';
  const map = [];
  for (const tn of textNodes) {
    const start = fullText.length;
    const end = start + tn.textContent.length;
    map.push({ node: tn, start, end });
    fullText += tn.textContent;
  }

  return { fullText, map };
}
