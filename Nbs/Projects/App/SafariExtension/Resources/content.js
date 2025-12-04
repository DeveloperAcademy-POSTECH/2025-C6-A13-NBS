function removeAds() {
  const adSelectors = [
    // 기본 ad 패턴
    '.ad', '.ads', '.ad-box', '.ad-container', '.ad-wrapper',
    '.advert', '.advertisement', '.advert-container',

    // class 포함 패턴
    '[class*="ad-"]',
    '[class*="ads-"]',
    '[class*="advert"]',
    '[class*="sponsor"]',
    '[class*="banner"]',

    // 네이버 뉴스/커뮤니티 광고
    '.r_group_comp.ad_box._da_banner',
    '.ad_area', '.ad_wrap', '.banner_ad', '.ad_item', '.adarea',
    '.ad_unit', '.ad_div', '.media_end_ad', '.ad_block',

    // data-* 광고
    '[data-ad]', '[data-ad-unit]', '[data-ad-type]','[data-ad-name]',
    '[data-ad-container]', '[data-google-query-id]',

    // id 패턴
    '[id*="ad"]',
    '[id*="ads"]',
    '[id*="ad-"]',
    '[id*="ad_"]',
    '[id*="banner"]',
    '[id*="sponsor"]',
    '[id^="nmap_"]',         // 네이버 광고
    '[id*="_tgtLREC"]',      // 네이버 iframe 광고

    // iframe
    'iframe[src*="ad"]',
    'iframe[src*="ads"]',
    'iframe[src*="doubleclick"]',
    'iframe[src*="googlesyndication"]',

    // 구글 광고
    '.google-ads', '.adsbygoogle', '[aria-label="advertisement"]',

    // 뉴스 기사형 광고
    '.ad_banner_area',
    '.news_ad',
    '.article_ad',
    '.ad_sidebar',
    '.ad_section',

    // 이미지 광고
    'img[src*="ad"]',
    'img[src*="banner"]',
    'img[src*="sponsor"]',
  ];

  adSelectors.forEach(selector => {
    document.querySelectorAll(selector).forEach(node => {
      node.remove();
    });
  });
}

//removeAds();

let isTulipMenuClick = false;
let lastSelectedHighlightType = 'what';
const isDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

//function showFirstHighlightToast(message) {
//  const existingToast = document.querySelector('.share-toast');
//  if (existingToast) {
//    existingToast.remove();
//  }
//  
//  const toast = document.createElement('div');
//  toast.className = 'share-toast';
//  
//  // 아이콘 추가
//  const icon = document.createElement('span');
//  icon.className = 'toast-icon';
//  
//  icon.innerHTML = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
//<path d="M12.0003 20.3337C16.6027 20.3337 20.3337 16.6027 20.3337 12.0003C20.3337 7.39795 16.6027 3.66699 12.0003 3.66699C7.39795 3.66699 3.66699 7.39795 3.66699 12.0003C3.66699 16.6027 7.39795 20.3337 12.0003 20.3337Z" stroke="#BBB4FD" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
//<path d="M12 15.3333V12" stroke="#BBB4FD" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
//<path d="M12 8.66699H12.0083" stroke="#BBB4FD" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
//</svg>`;
//  
//  // 텍스트 추가
//  const text = document.createElement('span');
//  text.textContent = message;
//  
//  toast.appendChild(icon);
//  toast.appendChild(text);
//  document.body.appendChild(toast);
//  
//  setTimeout(() => {
//    toast.classList.add('show')
//  }, 100);
//  
//  setTimeout(() => {
//    toast.classList.remove('show')
//    
//    setTimeout(() => {
//      toast.remove();
//    }, 500);
//  }, 3000);
//}

function getFixedHeaderHeight() {
  let fixedHeaderHeight = 0;
  const elements = document.querySelectorAll('body *');
  const viewportHeight = window.innerHeight;

  for (const el of elements) {
    // Basic visibility check
    if (el.offsetHeight === 0) {
      continue;
    }

    const style = window.getComputedStyle(el);
    if (style.position !== 'fixed' && style.position !== 'sticky') {
      continue;
    }
    
    const rect = el.getBoundingClientRect();

    // A header should be at the TOP of the viewport.
    // Let's allow for a small tolerance (e.g., 1px).
    if (rect.top <= 1) {
      // It also shouldn't be a full-screen overlay. Let's assume a header
      // is less than 40% of the viewport height. This is a heuristic.
      if (rect.height < viewportHeight * 0.4) {
        // We take the bottom-most edge of all such elements.
        fixedHeaderHeight = Math.max(fixedHeaderHeight, rect.bottom);
      }
    }
  }
  // Ensure the final value is not negative.
  return Math.max(0, fixedHeaderHeight);
}

function getMemoKey(type) {
  if (!type) return null;
  return 'memo' + type.charAt(0).toUpperCase() + type.slice(1);
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
        updateDraft(span);
      });
      
      container.appendChild(capsule);
    });
  }
}

function closeMemoBox() {
    const memoBox = document.getElementById('memo-box');
    if (!memoBox) return;

    const span = document.querySelector(`[data-draft-id="${memoBox.dataset.highlightId}"]`);
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
    updateDraft(span);

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
  memoBox.dataset.highlightId = span.dataset.draftId;
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
        const headerHeight = getFixedHeaderHeight();
        const spanRect = span.getBoundingClientRect();
        const scrollTop = window.scrollY || document.documentElement.scrollTop;
        const targetScrollTop = scrollTop + spanRect.top - headerHeight - 10;

        window.scrollTo({ top: targetScrollTop, behavior: 'smooth' });
        setTimeout(() => showMemoBox(span, null), 300);
        menu.remove();
      } else {
        const newType = buttonInfo.type;
        span.dataset.highlightType = newType;
        let comments = JSON.parse(span.dataset.comments || '[]');
        if (comments.length > 0) {
          comments.forEach(comment => comment.type = newType);
          span.dataset.comments = JSON.stringify(comments);
          renderCapsules(span)
        }
        updateDraft(span);
        
        menu.querySelectorAll('button').forEach(btn => btn.classList.remove('selected'));
        button.classList.add('selected');

        setTimeout(() => { isTulipMenuClick = false; }, 100);
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
      // window.scrollBy({ top: -scrollAmount, behavior: 'instant' });
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
  if (event.target.closest('.memo-capsule')) {
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
      const draftId = existingHighlight.dataset.draftId;
      const existingMenu = document.getElementById('tulip-menu');
      if (existingMenu) existingMenu.remove();
      const existingMemoBox = document.getElementById('memo-box');
      if (existingMemoBox) existingMemoBox.remove();
      const capsuleContainer = existingHighlight.nextElementSibling;
      if (capsuleContainer && capsuleContainer.classList.contains('capsule-container')) capsuleContainer.remove();
      const parent = existingHighlight.parentNode;
      existingHighlight.replaceWith(...existingHighlight.childNodes);
      if (parent) parent.normalize();
      deleteDraft(draftId);
    };
    if (comments.length > 0) showDeleteConfirmationModal(deleteHighlight);
    else deleteHighlight();
    return;
  }

  if (event.target.closest('#tulip-menu') || event.target.closest('#memo-box') || event.target.closest('#delete-confirm-modal')) return;

  const selection = window.getSelection();
  if (!selection.rangeCount) return;
  const range = selection.getRangeAt(0);
  const clickedElement = range.commonAncestorContainer;
  let textNode = clickedElement;
  if (textNode.nodeType !== Node.TEXT_NODE) {
    const treeWalker = document.createTreeWalker(clickedElement, NodeFilter.SHOW_TEXT);
    let currentNode;
    while (currentNode = treeWalker.nextNode()) {
      if (range.intersectsNode(currentNode)) {
        textNode = currentNode;
        break;
      }
    }
    if (textNode.nodeType !== Node.TEXT_NODE) return;
  }

  // 전체 텍스트를 만들고 클릭 위치를 fullText 상의 index로 변환
  const { fullText, map } = buildUnifiedText(textNode);

  let clickIndex = 0;
  for (const m of map) {
    if (m.node === textNode) {
      clickIndex = m.start + range.startOffset;
      break;
    }
  }

  const text = fullText;          // 기존 변수 재활용 → 최소 변경
  const clickPosition = clickIndex;

  let sentenceStart = 0;
  for (let i = clickPosition - 1; i >= 0; i--) {
    const char = text[i];
    if ('.?!'.includes(char)) {
      if (char === '.' && /\d/.test(text[i - 1]) && /\d/.test(text[i + 1])) continue;
      if (char === '.' && i > 0 && /[A-Z]/.test(text[i - 1]) && (i === 1 || text[i - 2] === ' ')) continue;
      if (isInsideQuotes(text, i)) continue;
      sentenceStart = i + 1;
      if (i + 1 < text.length && /\s/.test(text[i + 1])) sentenceStart++;
      break;
    }
  }

  let sentenceEnd = text.length;
  for (let i = clickPosition; i < text.length; i++) {
    const char = text[i];
    if ('.?!'.includes(char)) {
      if (char === '.' && /\d/.test(text[i - 1]) && /\d/.test(text[i + 1])) continue;
      if (char === '.' && i > 0 && /[A-Z]/.test(text[i - 1]) && (i === 1 || text[i - 2] === ' ')) continue;
      if (isInsideQuotes(text, i)) continue;
      const nextChar = text[i + 1];
      if ([])
      sentenceEnd = i + 1;
      break;
    }
  }

  const sentenceRange = document.createRange();

  // 문장 시작 위치 → 어느 node인지 찾기
  for (const m of map) {
    if (sentenceStart >= m.start && sentenceStart <= m.end) {
      sentenceRange.setStart(m.node, sentenceStart - m.start);
      break;
    }
  }

  // 문장 끝 위치 → 어느 node인지 찾기
  for (const m of map) {
    if (sentenceEnd >= m.start && sentenceEnd <= m.end) {
      sentenceRange.setEnd(m.node, sentenceEnd - m.start);
      break;
    }
  }

  let extractedText = sentenceRange.toString();
  const leadingWhitespaceLength = extractedText.length - extractedText.trimStart().length;
  if (leadingWhitespaceLength > 0) {
    const newSentenceStart = sentenceStart + leadingWhitespaceLength;
    for (const m of map) {
        if (newSentenceStart >= m.start && newSentenceStart <= m.end) {
            sentenceRange.setStart(m.node, newSentenceStart - m.start);
            break;
        }
    }
  }
  
  if (sentenceRange.toString().trim().length < 3) return;

  const allHighlights = document.querySelectorAll('.highlighted-text');
  for (const highlight of allHighlights) {
    const highlightRange = document.createRange();
    highlightRange.selectNodeContents(highlight);
    if (sentenceRange.compareBoundaryPoints(Range.END_TO_START, highlightRange) < 0 &&
        sentenceRange.compareBoundaryPoints(Range.START_TO_END, highlightRange) > 0) return;
  }

  const span = document.createElement('span');
  span.className = 'highlighted-text';
  span.dataset.highlightType = lastSelectedHighlightType;

  try {
    span.appendChild(sentenceRange.extractContents());
    sentenceRange.insertNode(span);
//    
//    const hasShown = getHasShownHighlightToast();
//    if (!hasShown) {
//      showFirstHighlightToast("공유하기를 눌러 탭탭에 저장할 수 있어요!");
//      setHasShownHighlightToast(true);
//      console.log('NBS[content.js] - "hasShownHighlightToast" 상태를 true로 변경 및 저장했습니다.');
//    }
    
    showTulipMenu(span);
    saveDraft(span);
  } catch (e) {
    console.error("하이라이트 적용 중 오류 발생:", e);
  }
});

//async function getHasShownHighlightToast() {
//  try {
//    const response = await browser.runtime.sendMessage({
//      action: "getHasShownHighlightToast"
//    });
//    return response?.hasShownHighlightToast || false;
//  } catch (e) {
//    console.error("NBS[content.js] - getHasShownHighlightToast 호출 실패:", e);
//    return false;
//  }
//}
//
//async function setHasShownHighlightToast(value) {
//  try {
//    const response = await browser.runtime.sendMessage({
//      action: "setHasShownHighlightToast",
//      value: value
//    });
//    return response;
//  } catch (e) {
//    console.error("NBS[content.js] - setHasShownHighlightToast 호출 실패:", e);
//    return null;
//  }
//}

async function saveDraft(highlightSpan) {
  const draft = {
    id: `draft-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
    sentence: highlightSpan.textContent.trim(),
    type: highlightSpan.dataset.highlightType,
    comments: JSON.parse(highlightSpan.dataset.comments || '[]'),
    url: window.location.href,
    createdAt: new Date().toISOString(),
    isDraft: true
  };
  
  try {
    const data = await browser.storage.local.get('draftHighlights');
    const drafts = data.draftHighlights || [];
    drafts.push(draft);
    await browser.storage.local.set({ draftHighlights: drafts });
    console.log('새로운 하이라이트 초안을 저장했습니다:', draft);
    highlightSpan.dataset.draftId = draft.id;
  } catch (e) {
    console.error('초안 저장 중 오류 발생:', e);
  }
}

async function updateDraft(highlightSpan) {
  const draftId = highlightSpan.dataset.draftId;
  if (!draftId) {
    console.log("updateDraft: 초안 ID가 없는 하이라이트입니다. 업데이트를 건너뜁니다.");
    return;
  }
  
  try {
    const data = await browser.storage.local.get('draftHighlights');
    const drafts = data.draftHighlights || [];
    const draftIndex = drafts.findIndex(d => d.id === draftId);
    
    if (draftIndex > -1) {
      drafts[draftIndex].type = highlightSpan.dataset.highlightType;
      drafts[draftIndex].comments = JSON.parse(highlightSpan.dataset.comments || '[]');
      
      await browser.storage.local.set({ draftHighlights: drafts });
      console.log('하이라이트 초안을 수정했습니다:', drafts[draftIndex]);
    } else {
      console.warn("updateDraft: 수정할 초안을 찾지 못했습니다:", draftId);
    }
  } catch (e) {
    console.error('초안 수정 중 오류 발생:', e);
  }
}

async function deleteDraft(draftId) {
  if (!draftId) {
    console.log("deleteDraft: 초안 ID가 없습니다. 삭제를 건너뜜니다.");
    return;
  }
  
  try {
    const data = await browser.storage.local.get('draftHighlights');
    let drafts = data.draftHighlights || [];
    const updatedDrafts = drafts.filter(d => d.id !== draftId);
    
    await browser.storage.local.set({ draftHighlights: updatedDrafts });
    console.log('하이라이트 초안을 삭제했습니다:', draftId);
  } catch (e) {
    console.error('초안 삭제 중 오류 발생:', e);
  }
}



function findAndApplyHighlights(savedHighlights) {
  if (!savedHighlights || savedHighlights.length === 0) return;
  
  const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
  let textNode;
  while (textNode = walker.nextNode()) {
    for (const saved of savedHighlights) {
      if (saved.applied) continue;
      
      const index = textNode.textContent.indexOf(saved.sentence);
      if (index !== -1) {
        const range = document.createRange();
        range.setStart(textNode, index);
        range.setEnd(textNode, index + saved.sentence.length);
        
        const span = document.createElement('span');
        span.className = 'highlighted-text';
        
        if (saved.isDraft) {
          span.dataset.draftId = saved.id;
        } else if (saved.id) {
          span.dataset.id = saved.id;
        }
        
        const type = saved.type || saved.highlightType;
        span.dataset.highlightType = type;
        span.dataset.comments = JSON.stringify(saved.comments || '[]');
        
        try {
          range.surroundContents(span);
          renderCapsules(span);
          saved.applied = true;
          walker.currentNode = document.body;
          break;
        } catch (e) {
          console.error("하이라이트 적용 중 오류 발생:", e);
        }
      }
    }
  }
}

async function loadHighlights() {
  const url = window.location.href;
  try {
    const data = await browser.storage.local.get([url, 'draftHighlights']);
    
    const savedHighlights = data[url] || [];
    const allDrafts = data.draftHighlights || [];
    
    const draftsForThisPage = allDrafts.filter(draft => draft.url === url);
    
    const officialHighlights = savedHighlights.filter(h => !draftsForThisPage.some(d => d.text === h.text));
    
    const highlightsToApply = [...officialHighlights, ...draftsForThisPage];
    
    setTimeout(() => {
      document.querySelectorAll('.highlighted-text').forEach(span => {
        if (span.parentNode) {
            span.replaceWith(...span.childNodes);
        }
      });
      document.querySelectorAll('.capsule-container, #tulip-menu, #memo-box').forEach(el => el.remove());

      findAndApplyHighlights(highlightsToApply);
    }, 1000);
  } catch (e) {
    console.error("하이라이트 로딩 중 오류 발생:", e);
  }
}

loadHighlights();


browser.runtime.sendMessage({ greeting: "hello" }).then((response) => {
  console.log("Received response: ", response);
});

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
  console.log("Received request: ", request);
});

window.addEventListener('pageshow', function(event) {
  if (event.persisted) {
    console.log('Page was loaded from bfcache. Reloading highlights.');
    loadHighlights();
  }
});

document.addEventListener('visibilitychange', () => {
  if (document.visibilityState === 'visible') {
    console.log('Tab is now visible. Reloading highlights from local storage.');
    loadHighlights();
  }
});

document.addEventListener('click', function(event) {
    const tulipMenu = document.getElementById('tulip-menu');
    const memoBox = document.getElementById('memo-box');
    const clickedHighlight = event.target.closest('.highlighted-text');

    if (memoBox && !memoBox.contains(event.target) && !event.target.closest('.memo-capsule')) {
        closeMemoBox();
    }

    if (clickedHighlight) {
        if (tulipMenu && tulipMenu.dataset.highlightId === clickedHighlight.dataset.draftId) {
            return;
        }
        showTulipMenu(clickedHighlight);
        return;
    }

    if (tulipMenu) {
        tulipMenu.remove();
    }
});

function buildUnifiedText(clickedNode) {
  let container = clickedNode;

  // 문장 컨테이너 찾기 (최소 수정 → 기존 구조 유지)
  while (container && container !== document.body) {
    if (container.matches?.('span.article_p, p, div')) break;
    container = container.parentNode;
  }
  if (!container) container = document.body;

  // 모든 텍스트 노드 모으기
  const textNodes = [];
  const walker = document.createTreeWalker(container, NodeFilter.SHOW_TEXT);
  let node;
  while (node = walker.nextNode()) {
    if (node.textContent.trim().length > 0) textNodes.push(node);
  }

  // 하나의 문자열로 병합 + 매핑 정보 생성
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
