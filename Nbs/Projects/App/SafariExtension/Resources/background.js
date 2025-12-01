browser.runtime.onMessage.addListener((message, sender, sendResponse) => {
//  console.log("background.js: 수신된 메세지:", message);
  if (message.action == "getLastestDataForURL") {
    console.log("background.js: 네이티브로 메시지 보냄 →", message.action);
    browser.runtime.sendNativeMessage("com.Nbs.dev.ADA.app", message)
      .then(response => {
        console.log("background.js: 네이티브 응답:", response);
        sendResponse(response);
      })
      .catch(error => {
        console.error("background.js: 네이티브 메시지 오류:", error);
        sendResponse({ error: error.message });
      });
    return true;
  }
  return false;
});
