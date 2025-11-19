browser.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === "getLatestDataForURL") {
    console.log("background.js: content.js로부터 메시지 수신, 네이티브 코드로 전달합니다.", message);
    
    browser.runtime.sendNativeMessage("com.Nbs.dev.ADA.app", message)
    .then(response => {
      console.log("background.js: 네이티브로부터 받은 전체 응답:", response);
      console.log("background.js: 실제 데이터를 content.js로 전달합니다:", response);
      sendResponse(response);
    })
    .catch(error => {
      console.error("background.js: 네이티브 메시지 전송 오류:", error);
      sendResponse({ error: error.message });
    });
    
    return true;
  }
  
  return false;
});

