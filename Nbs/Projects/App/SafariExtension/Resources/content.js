let isTulipMenuClick = false;

// 페이지의 고정 헤더 높이를 계산하는 함수
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

// 메모 데이터 속성 키를 camelCase로 변환하는 헬퍼 함수
function getMemoKey(type) {
  if (!type) return null;
  return 'memo' + type.charAt(0).toUpperCase() + type.slice(1);
}

// 메모 캡슐들을 렌더링하는 함수
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
        
        const isAlreadyClicked = capsule.classList.contains(`clicked-${comment.type}`);
        const memoBoxOpenForThisCapsule = document.getElementById('memo-box') && Number(document.getElementById('memo-box').dataset.editingId) === comment.id;

        // 이전에 클릭된 캡슐의 'clicked' 클래스 제거
        document.querySelectorAll('.memo-capsule.clicked-what, .memo-capsule.clicked-why, .memo-capsule.clicked-detail').forEach(c => {
          c.classList.remove('clicked-what', 'clicked-why', 'clicked-detail');
        });

        if (isAlreadyClicked && memoBoxOpenForThisCapsule) {
          // 이미 클릭된 캡슐을 다시 클릭하면 메모 상자를 닫고 캡슐 스타일을 원래대로 되돌림
          const existingMemoBox = document.getElementById('memo-box');
          if (existingMemoBox) existingMemoBox.remove();
          return; // 이벤트 처리 중단
        }

        // 현재 캡슐에 'clicked' 클래스 추가
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

function showMemoBox(span, memoId = null) {
  const existingMemoBox = document.getElementById('memo-box');
  if (existingMemoBox) {
    existingMemoBox.remove();
  }
  
  const comments = JSON.parse(span.dataset.comments || '[]');
  const currentComment = memoId ? comments.find(m => m.id === memoId) : null;
  
  const memoBox = document.createElement('div');
  memoBox.id = 'memo-box';
  if (memoId) {
    memoBox.dataset.editingId = memoId;
  }
  memoBox.addEventListener('click', e => e.stopPropagation());
  
  const currentHighlightType = currentComment ? currentComment.type : span.dataset.highlightType;
  const existingText = currentComment ? currentComment.text : '';
  
  const placeholders = {
    'what': '주제, 핵심 내용을 한 줄로 정리해 보세요',
    'why': '현상의 이유, 배경을 남겨보세요',
    'detail': '이어지는 내용이나 생각을 입력 해주세요'
    
  }
  const textarea = document.createElement('textarea');
  textarea.placeholder = placeholders[currentHighlightType] || '메모를 입력하세요...';
  textarea.value = existingText;
  memoBox.appendChild(textarea);

  textarea.addEventListener('blur', () => {
    const commentText = textarea.value.trim();
    let updatedComments = JSON.parse(span.dataset.comments || '[]');

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
          type: currentHighlightType,
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
  });
  
  if (memoId) {
    const capsuleContainer = span.nextElementSibling;
    if (capsuleContainer && capsuleContainer.classList.contains('capsule-container')) {
      capsuleContainer.after(memoBox);
    } else {
      span.after(memoBox);
    }
  } else {
    span.after(memoBox);
  }
}

// 튤립 메뉴를 표시하는 함수
function showTulipMenu(span) {
  // 메모 박스가 열려 있으면 튤립 메뉴를 열지 않음
  if (document.getElementById('memo-box')) {
    return;
  }

  const existingMenu = document.getElementById('tulip-menu');
  if (existingMenu) existingMenu.remove();
  
  const menu = document.createElement('div');
  menu.id = 'tulip-menu';
  menu.addEventListener('click', e => e.stopPropagation());
  
  const buttons = [
    { text: 'W', type: 'what' },
    { text: 'W', type: 'why' },
    { text: 'D', type: 'detail' },
    { text: '', type: 'memo' }
  ];
  
  buttons.forEach(buttonInfo => {
    const button = document.createElement('button');
    if (buttonInfo.type === 'memo') {
      button.innerHTML = `
  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path fill="#5c5c6e" fill-rule="evenodd" d="m12.328 7.024-6.782 6.782-.925 3.45-.608 2.273a.375.375 0 0 0 .458.458l2.272-.609 3.45-.925h.001l6.782-6.782zm7.453.785-3.59-3.59a.75.75 0 0 0-1.058 0l-1.852 1.852 4.648 4.648 1.852-1.852a.75.75 0 0 0 0-1.058" clip-rule="evenodd"/></svg>
  `;
    } else {
      button.textContent = buttonInfo.text;
    }
    
    button.dataset.highlightType = buttonInfo.type;

    
    button.addEventListener('click', (event) => {
      event.stopPropagation();
      
      if (buttonInfo.type === 'memo') {
        const headerHeight = getFixedHeaderHeight();
        const spanRect = span.getBoundingClientRect();
        const scrollTop = window.scrollY || document.documentElement.scrollTop;
        const targetScrollTop = scrollTop + spanRect.top - headerHeight - 10;
        
        window.scrollTo({ top: targetScrollTop, behavior: 'smooth' });
        
        setTimeout(() => showMemoBox(span, null), 300);
        
        menu.remove(); // 메모 버튼 클릭 시 툴팁 메뉴를 닫음
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
      }
    });
    menu.appendChild(button);
  });
  
  document.body.appendChild(menu);
  
  const spanRect = span.getBoundingClientRect();
  const menuRect = menu.getBoundingClientRect();
  menu.style.position = 'absolute';
  menu.style.top = `${window.scrollY + spanRect.top - menuRect.height - 10}px`;
  menu.style.left = `${window.scrollX + spanRect.left + (spanRect.width / 2) - (menuRect.width / 2)}px`;
}

// 삭제 확인 모달을 표시하는 함수
function showDeleteConfirmationModal(onConfirm) {
  const existingModal = document.getElementById('delete-confirm-modal');
  if (existingModal) existingModal.remove();
  
  const modal = document.createElement('div');
  modal.id = 'delete-confirm-modal';
  modal.addEventListener('click', (e) => {
    if (e.target.id === 'delete-confirm-modal') {
      modal.remove();
    }
  });
  
  const modalContent = document.createElement('div');
  modalContent.className = 'modal-content';
  
  const title = document.createElement('h3');
  title.textContent = '메모를 삭제할까요?';
  
  const message = document.createElement('p');
  message.innerHTML = '삭제한 메모는 복구할 수 없어요';
  
  const separator = document.createElement('div');
  separator.className = 'modal-separator';
  
  const verticalSeparator = document.createElement('div');
  verticalSeparator.className = 'vertical-separator';

  const buttonContainer = document.createElement('div');
  buttonContainer.className = 'modal-buttons';
  
  const cancelButton = document.createElement('button');
  cancelButton.textContent = '취소';
  cancelButton.className = 'cancel-btn';
  cancelButton.onclick = () => modal.remove();
  
  const deleteButton = document.createElement('button');
  deleteButton.textContent = '삭제';
  deleteButton.className = 'delete-btn';
  deleteButton.onclick = () => {
    onConfirm();
    modal.remove();
  };
  
  buttonContainer.appendChild(cancelButton);
  buttonContainer.appendChild(verticalSeparator);
  buttonContainer.appendChild(deleteButton);
  modalContent.appendChild(title);
  modalContent.appendChild(message);
  modalContent.appendChild(separator);
  modalContent.appendChild(buttonContainer);
  modal.appendChild(modalContent);
  
  document.body.appendChild(modal);
}

// 더블탭 이벤트 처리ㄱ
document.addEventListener('dblclick', function(event) {
  // 메모 캡슐 내부에서 더블 클릭 시 이벤트 전파 및 기본 동작 방지
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
      if (capsuleContainer && capsuleContainer.classList.contains('capsule-container')) {
        capsuleContainer.remove();
      }
      
      existingHighlight.replaceWith(...existingHighlight.childNodes);
      
      deleteDraft(draftId);
    };
    
    if (comments.length > 0) {
      showDeleteConfirmationModal(deleteHighlight);
    } else {
      deleteHighlight();
    }
    
    return;
  }
  
  if (event.target.closest('#tulip-menu') || event.target.closest('#memo-box') || event.target.closest('#delete-confirm-modal')) {
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
    while(currentNode = treeWalker.nextNode()) {
      const nodeRange = document.createRange();
      nodeRange.selectNodeContents(currentNode);
      if (range.intersectsNode(nodeRange)) {
        textNode = currentNode;
        break;
      }
    }
    if (textNode.nodeType !== Node.TEXT_NODE) return;
  }
  
  const text = textNode.textContent;
  const clickPosition = range.startOffset;
  
  let sentenceStart = 0;
  for (let i = clickPosition - 1; i >= 0; i--) {
    const char = text[i];
    if ('.?!'.includes(char)) {
      if (char === '.' && /\d/.test(text[i-1]) && /\d/.test(text[i+1])) {
        continue;
      }
      sentenceStart = i + 1;
      if (i + 1 < text.length && /\s/.test(text[i + 1])) {
        sentenceStart++;
      }
      break;
    }
  }
  
  let sentenceEnd = text.length;
  for (let i = clickPosition; i < text.length; i++) {
    const char = text[i];
    if ('.?!'.includes(char)) {
      if (char === '.' && /\d/.test(text[i-1]) && /\d/.test(text[i+1])) {
        continue;
      }
      sentenceEnd = i + 1;
      break;
    }
  }
  
  const sentenceRange = document.createRange();
  sentenceRange.setStart(textNode, sentenceStart);
  sentenceRange.setEnd(textNode, sentenceEnd);

  const extractedText = sentenceRange.toString().trim();
  if (extractedText.length < 3) { // 최소 3자 미만은 하이라이팅하지 않음
    return;
  }

  // 이미 하이라이트된 영역과 겹치는지 확인
  const allHighlights = document.querySelectorAll('.highlighted-text');
  for (const highlight of allHighlights) {
    const highlightRange = document.createRange();
    highlightRange.selectNodeContents(highlight);
    if (sentenceRange.compareBoundaryPoints(Range.END_TO_START, highlightRange) < 0 &&
        sentenceRange.compareBoundaryPoints(Range.START_TO_END, highlightRange) > 0) {
      // 겹치는 부분이 있으면 하이라이팅 방지
      return;
    }
  }
  
  const span = document.createElement('span');
  span.className = 'highlighted-text';
  span.dataset.highlightType = 'what';
  
  try {
    span.appendChild(sentenceRange.extractContents());
    sentenceRange.insertNode(span);
    showTulipMenu(span);
    saveDraft(span);
  } catch (e) {
    console.error("하이라이트 적용 중 오류 발생:", e);
  }
});

// 페이지 내 클릭 이벤트 처리
document.addEventListener('click', function(event) {
  const target = event.target;
  const isClickOnHighlight = target.closest('.highlighted-text') && !target.closest('#tulip-menu') && !target.closest('#memo-box') && !target.closest('.capsule-container');
  
  if (isClickOnHighlight) {
    event.stopPropagation();
    const existingMenu = document.getElementById('tulip-menu');
    if (existingMenu) {
      existingMenu.remove();
    } else {
      showTulipMenu(target.closest('.highlighted-text'));
    }
    return;
  }
  
  if (!target.closest('#tulip-menu')) {
    const existingMenu = document.getElementById('tulip-menu');
    if (existingMenu) existingMenu.remove();
  }
  
  if (!target.closest('#memo-box')) {
    const existingMemoBox = document.getElementById('memo-box');
    if (existingMemoBox) {
      existingMemoBox.remove();
      // 메모 박스가 외부 클릭으로 닫힐 때 모든 캡슐에서 'clicked' 클래스 제거
      document.querySelectorAll('.memo-capsule.clicked-what, .memo-capsule.clicked-why, .memo-capsule.clicked-detail').forEach(c => {
        c.classList.remove('clicked-what', 'clicked-why', 'clicked-detail');
      });
    }
  }
});

// 초안 처리 로직
async function saveDraft(highlightSpan) {
  const draft = {
    id: `draft-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`, // 고유 ID
    sentence: highlightSpan.textContent,
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

// 초안 하이라이트 수정 메소드
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

// 초안 하이라이트 삭제 메소드
async function deleteDraft(draftId) {
  if (!draftId) {
    console.log("deleteDraft: 초안 ID가 없습니다. 삭제를 건너뜁니다.");
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


// --- 페이지 로드 및 하이라이트 렌더링 로직 --
// 하이라이트 정보 저장 메소드
function saveHighlights() {
  console.warn('saveHighlights() is deprecated. Use updateDraft() or saveDraft().');
}

// 하이라이트 적용 메소드
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

// 하이라이트 읽기 메소드
async function loadHighlights() {
  const url = window.location.href;
  try {
    const data = await browser.storage.local.get([url, 'draftHighlights']);
    
    const savedHighlights = data[url] || [];
    const allDrafts = data.draftHighlights || [];
    
    const draftsForThisPage = allDrafts.filter(draft => draft.url === url);
    
    const officialHighlights = savedHighlights.filter(h => !draftsForThisPage.some(d => d.text === h.text));
    
    const highlightsToApply = [...officialHighlights, ...draftsForThisPage];
    
    findAndApplyHighlights(highlightsToApply);
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

// --- 네이티브 앱 <-> 사파리 동기화 로직 ---

// 최신 데이터 동기화 메소드
async function syncHighlightsFromServer() {
  console.log("[%cSYNC%c] 서버와 동기화를 시도합니다...", "color: blue; font-weight: bold;", "");
  try {
    const response = await browser.runtime.sendMessage({
      action: "getLatestDataForURL",
      url: window.location.href
    });
    
    console.log("[%cSYNC%c] Swift로부터 받은 전체 응답:", "color: blue; font-weight: bold;", "", response);
    
    if (response && response.highlights) {
      console.log("[%cSYNC%c] 서버로부터 최신 하이라이트 수신: %d개", "color: blue; font-weight: bold;", "", response.highlights.length);
      
      document.querySelectorAll('.highlighted-text, .capsule-container, #tulip-menu, #memo-box').forEach(el => el.remove());
      
      await browser.storage.local.set({ [window.location.href]: response.highlights });
      
      const data = await browser.storage.local.get('draftHighlights');
      const allDrafts = data.draftHighlights || [];
      if (allDrafts.length > 0) {
        const otherDrafts = allDrafts.filter(draft => draft.url !== window.location.href);
        await browser.storage.local.set({ draftHighlights: otherDrafts });
      }
      
      findAndApplyHighlights(response.highlights);
    } else {
      console.warn("[%cSYNC%c] 서버로부터 받은 데이터에 하이라이트가 없습니다.", "color: orange; font-weight: bold;", "");
    }
  } catch (e) {
    console.error("[%cSYNC%c] 서버와 동기화 중 오류 발생:", "color: red; font-weight: bold;", "", e);
  }
}

// 페이지가 bfcache에서 로드될 때 하이라이트를 다시 적용
window.addEventListener('pageshow', function(event) {
  if (event.persisted) {
    console.log('Page was loaded from bfcache. Reloading highlights.');
    loadHighlights();
  }
});

// 탭이 다시 활성화될 때 서버와 동기화
document.addEventListener('visibilitychange', () => {
  if (document.visibilityState === 'visible') {
    console.log('Tab is now visible. Syncing with server.');
    syncHighlightsFromServer();
  }
});

