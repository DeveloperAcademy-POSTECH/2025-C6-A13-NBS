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
  
  const memos = JSON.parse(span.dataset.memos || '[]');
  
  if (memos.length > 0) {
    const container = document.createElement('div');
    container.className = 'capsule-container';
    span.after(container);
    
    memos.forEach(memo => {
      const capsule = document.createElement('div');
      capsule.className = 'memo-capsule';
      capsule.dataset.memoType = memo.type;
      
      const textPreview = document.createElement('span');
      textPreview.className = 'capsule-text';
      textPreview.textContent = memo.text;
      
      const deleteBtn = document.createElement('button');
      deleteBtn.className = 'capsule-delete-btn';
      deleteBtn.textContent = 'X';
      
      capsule.appendChild(textPreview);
      capsule.appendChild(deleteBtn);
      
      capsule.addEventListener('click', (e) => {
        e.stopPropagation();
        showMemoBox(span, memo.id);
      });
      
      deleteBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        
        const memoBox = document.getElementById('memo-box');
        if (memoBox && Number(memoBox.dataset.editingId) === memo.id) {
          memoBox.remove();
        }
        
        const updatedMemos = JSON.parse(span.dataset.memos || '[]').filter(m => m.id !== memo.id);
        span.dataset.memos = JSON.stringify(updatedMemos);
        renderCapsules(span);
        updateDraft(span);
      });
      
      container.appendChild(capsule);
    });
  }
}

function showMemoBox(span, memoId = null) {
  const existingMemoBox = document.getElementById('memo-box');
  if (existingMemoBox) existingMemoBox.remove();
  
  const memos = JSON.parse(span.dataset.memos || '[]');
  const currentMemo = memoId ? memos.find(m => m.id === memoId) : null;
  
  const memoBox = document.createElement('div');
  memoBox.id = 'memo-box';
  if (memoId) {
    memoBox.dataset.editingId = memoId;
  }
  memoBox.addEventListener('click', e => e.stopPropagation());
  
  const currentHighlightType = currentMemo ? currentMemo.type : span.dataset.highlightType;
  const existingText = currentMemo ? currentMemo.text : '';
  
  const textarea = document.createElement('textarea');
  textarea.placeholder = `'${currentHighlightType}'에 대한 메모를 입력하세요...`;
  textarea.value = existingText;
  
  const buttonContainer = document.createElement('div');
  buttonContainer.className = 'memo-buttons';
  
  const cancelButton = document.createElement('button');
  cancelButton.textContent = '취소';
  cancelButton.onclick = () => memoBox.remove();
  
  const saveButton = document.createElement('button');
  saveButton.textContent = '저장';
  saveButton.onclick = () => {
    const memoText = textarea.value.trim();
    let updatedMemos = JSON.parse(span.dataset.memos || '[]');
    
    if (memoId) {
      const memoIndex = updatedMemos.findIndex(m => m.id === memoId);
      if (memoIndex > -1) {
        if (memoText) {
          updatedMemos[memoIndex].text = memoText;
        } else {
          updatedMemos.splice(memoIndex, 1);
        }
      }
    } else {
      if (memoText) {
        const newMemo = {
          id: Date.now(),
          type: currentHighlightType,
          text: memoText
        };
        updatedMemos.push(newMemo);
      }
    }
    
    span.dataset.memos = JSON.stringify(updatedMemos);
    memoBox.remove();
    renderCapsules(span);
    updateDraft(span);
  };
  
  buttonContainer.appendChild(cancelButton);
  buttonContainer.appendChild(saveButton);
  memoBox.appendChild(textarea);
  memoBox.appendChild(buttonContainer);
  
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
  const existingMenu = document.getElementById('tulip-menu');
  if (existingMenu) existingMenu.remove();
  
  const menu = document.createElement('div');
  menu.id = 'tulip-menu';
  menu.addEventListener('click', e => e.stopPropagation());
  
  const buttons = [
    { text: 'what', type: 'what' },
    { text: 'why', type: 'why' },
    { text: 'detail', type: 'detail' },
    { text: '메모', type: 'memo' }
  ];
  
  buttons.forEach(buttonInfo => {
    const button = document.createElement('button');
    button.textContent = buttonInfo.text;
    
    if (buttonInfo.type !== 'memo') {
      button.dataset.highlightType = buttonInfo.type;
    } else {
      // 메모 버튼은 별도 스타일을 가질 수 있으므로 data-attribute를 설정하지 않거나 특별한 값을 설정할 수 있습니다.
    }
    
    button.addEventListener('click', (event) => {
      event.stopPropagation();
      
      if (buttonInfo.type === 'memo') {
        const headerHeight = getFixedHeaderHeight();
        const spanRect = span.getBoundingClientRect();
        const scrollTop = window.scrollY || document.documentElement.scrollTop;
        const targetScrollTop = scrollTop + spanRect.top - headerHeight - 10;
        
        window.scrollTo({ top: targetScrollTop, behavior: 'smooth' });
        
        setTimeout(() => showMemoBox(span), 300);
        
        menu.remove();
      } else {
        const newType = buttonInfo.type;
        span.dataset.highlightType = newType;
        
        let memos = JSON.parse(span.dataset.memos || '[]');
        if (memos.length > 0) {
          memos.forEach(memo => memo.type = newType);
          span.dataset.memos = JSON.stringify(memos);
          renderCapsules(span);
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
  title.textContent = '하이라이트를 취소할까요?';
  
  const message = document.createElement('p');
  message.innerHTML = '하이라이트 취소 시<br>하이라이트 메모도 함께 삭제되어요';
  
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
  buttonContainer.appendChild(deleteButton);
  modalContent.appendChild(title);
  modalContent.appendChild(message);
  modalContent.appendChild(buttonContainer);
  modal.appendChild(modalContent);
  
  document.body.appendChild(modal);
}

// 더블탭 이벤트 처리
document.addEventListener('dblclick', function(event) {
  const existingHighlight = event.target.closest('.highlighted-text');
  if (existingHighlight) {
    event.preventDefault();
    event.stopPropagation();
    
    const memos = JSON.parse(existingHighlight.dataset.memos || '[]');
    
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
    
    if (memos.length > 0) {
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
    showTulipMenu(target.closest('.highlighted-text'));
    return;
  }
  
  if (!target.closest('#tulip-menu')) {
    const existingMenu = document.getElementById('tulip-menu');
    if (existingMenu) existingMenu.remove();
  }
  
  if (!target.closest('#memo-box')) {
    const existingMemoBox = document.getElementById('memo-box');
    if (existingMemoBox) existingMemoBox.remove();
  }
});




// 초안 처리 로직
async function saveDraft(highlightSpan) {
  const draft = {
    id: `draft-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`, // 고유 ID
    text: highlightSpan.textContent,
    type: highlightSpan.dataset.highlightType,
    memos: JSON.parse(highlightSpan.dataset.memos || '[]'),
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
      drafts[draftIndex].memos = JSON.parse(highlightSpan.dataset.memos || '[]');
      
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
      
      const index = textNode.textContent.indexOf(saved.text);
      if (index !== -1) {
        const range = document.createRange();
        range.setStart(textNode, index);
        range.setEnd(textNode, index + saved.text.length);
        
        const span = document.createElement('span');
        span.className = 'highlighted-text';
        
        if (saved.isDraft) {
          span.dataset.draftId = saved.id;
        } else if (saved.id) {
          span.dataset.id = saved.id;
        }
        
        const type = saved.type || saved.highlightType;
        span.dataset.highlightType = type;
        span.dataset.memos = JSON.stringify(saved.memos || '[]');
        
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

