var arguments = process.argv.splice(2);
go(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7]);
function go(projPath, webPath, jsNames, workFolder, useUglyRecord, doMakeItUgly, donotFormat, replaceIt) {
    var beautify = require('js-beautify').js, esprima = require('esprima'), fs = require('fs'), path = require('path');
    projPath = projPath || '../../';
    if(!/\/$/.test(projPath) || !/\\\\$/.test(projPath)) {
        projPath = projPath + '/';
    }
    webPath = webPath || '../../bin/h5/';
    if(!/\/$/.test(webPath) || !/\\\\$/.test(webPath)) {
        webPath = webPath + '/';
    }
    jsNames = jsNames || 'Root.max.js';
    var layaResPath = webPath + 'res/Laya';
    var jsNameArr = jsNames.split(/,\s*/);
    var rootJsPaths = [];
    for(var i = 0, len = jsNameArr.length; i < len; i++) {
        rootJsPaths.push(webPath + jsNameArr[i]);
    }
    var startAt = (new Date()).getTime();
    useUglyRecord = 'true' == useUglyRecord;
    doMakeItUgly = 'true' == doMakeItUgly;
    donotFormat = 'true' == donotFormat;
    replaceIt = 'true' == replaceIt;
    workFolder = workFolder || '';
    if(!/\/$/.test(workFolder) || !/\\\\$/.test(workFolder)) {
        workFolder = workFolder + '/';
    }
    console.log('run esprima, projPath = ' + projPath + ', webPath = ' + webPath + ', jsNames = ' + jsNames + ', useUglyRecord = ' + useUglyRecord + ', doMakeItUgly = ' + doMakeItUgly + ', donotFormat = ' + donotFormat + ', replaceIt = ' + replaceIt);
    
    var errorMsg, astSaved1, astSaved2;

    // 以下变量的派生不予混淆
    var stopUglyMap = {};
    var stopUglyNames = ['Browser', 'window', 'wx', 'OPEN_DATA'];
    for(var i = 0, len = stopUglyNames.length; i < len; i++) {
        stopUglyMap[stopUglyNames[i]] = true;
    }
    
    const cfgPkgRe = /automatic\.cfgs\./;

    // 以下变量不予混淆
    var protectedMap = {};
    // js内置对象
    var jsBuiltIns = ['Array', 'ArrayBuffer', 'AsyncFunction', 'Atomics', 'BigInt', 'Boolean', 'DataView', 'Date', 'Error', 'EvalError', 'Float32Array', 'Float64Array', 'Function', 'Generator', 'GeneratorFunction', 'Infinity', 'Int16Array', 'Int32Array', 'Int8Array', 'InternalError', 'Intl', 'Collator', 'DateTimeFormat', 'NumberFormat', 'PluralRules', 'RelativeTimeFormat', 'JSON', 'Map', 'Math', 'NaN', 'Number', 'Object', 'Promise', 'Proxy', 'RangeError', 'ReferenceError', 'Reflect', 'RegExp', 'Set', 'SharedArrayBuffer', 'String', 'Symbol', 'SyntaxError', 'TypeError', 'TypedArray', 'URIError', 'Uint16Array', 'Uint32Array', 'Uint8Array', 'Uint8ClampedArray', 'WeakMap', 'WeakSet', 'WebAssembly', 'decodeURI', 'decodeURIComponent', 'encodeURI', 'encodeURIComponent', 'escape', 'eval', 'isFinite', 'isNaN', 'null', 'parseFloat', 'parseInt', 'undefined', 'unescape', 'uneval'];
    for(var i = 0, len = jsBuiltIns.length; i < len; i++) {
        protectedMap[jsBuiltIns[i]] = true;
    }

    // 关于Object
    // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty
    var jsObjectRelatives = ['configurable', 'enumerable', 'value', 'writable', 'get', 'set'];
    for(var i = 0, len = jsObjectRelatives.length; i < len; i++) {
        protectedMap[jsObjectRelatives[i]] = true;
    }

    // 关于window
    // https://developer.mozilla.org/en-US/docs/Web/API/EventTarget
    var eventTargetRelatives = ['addEventListener', 'removeEventListener', 'dispatchEvent'];
    // https://developer.mozilla.org/en-US/docs/Web/API/Window
    var windowRelatives = ['closed', 'console', 'content', '_content', 'controllers', 'customElements', 'crypto', 'defaultStatus', 'devicePixelRatio', 'dialogArguments', 'directories', 'document', 'DOMMatrix', 'DOMMatrixReadOnly', 'DOMPoint', 'DOMPointReadOnly', 'DOMQuad', 'DOMRect', 'DOMRectReadOnly', 'event', 'frameElement', 'frames', 'fullScreen', 'globalStorage', 'history', 'innerHeight', 'innerWidth', 'isSecureContext', 'length', 'location', 'locationbar', 'localStorage', 'menubar', 'messageManager', 'mozAnimationStartTime', 'mozInnerScreenX', 'mozInnerScreenY', 'mozPaintCount', 'name', 'navigator', 'opener', 'orientation', 'outerHeight', 'outerWidth', 'pageXOffset', 'pageYOffset', 'parent', 'performance', 'personalbar', 'pkcs11', 'returnValue', 'screen', 'screenX', 'screenLeft', 'screenY', 'screenTop', 'scrollbars', 'scrollMaxX', 'scrollMaxY', 'scrollX', 'scrollY', 'self', 'sessionStorage', 'sidebar', 'speechSynthesis', 'status', 'statusbar', 'toolbar', 'top', 'visualViewport', 'window', 'caches', 'indexedDB', 'isSecureContext', 'origin'];
    for(var i = 0, len = eventTargetRelatives.length; i < len; i++) {
        protectedMap[eventTargetRelatives[i]] = true;
    }
    for(var i = 0, len = windowRelatives.length; i < len; i++) {
        protectedMap[windowRelatives[i]] = true;
    }

    // js接口
    var jsBuiltInFuncs = ['abs', 'acos', 'acosh', 'add', 'all', 'anchor', 'and', 'apply', 'asin', 'asinh', 'assign', 'atan', 'atan2', 'atanh', 'big', 'bind', 'blink', 'bold', 'call', 'catch', 'cbrt', 'ceil', 'charAt', 'charCodeAt', 'clear', 'clz32', 'codePointAt', 'compareExchange', 'compile', 'compileStreaming', 'concat', 'construct', 'copyWithin', 'cos', 'cosh', 'create', 'customSections', 'defineProperties', 'defineProperty', 'delete', 'deleteProperty', 'endsWith', 'entries', 'enumerate', 'eval', 'every', 'exchange', 'exec', 'exp', 'expm1', 'exports', 'fill', 'filter', 'finally', 'find', 'findIndex', 'fixed', 'flat', 'flatMap', 'floor', 'fontcolor', 'fontsize', 'for', 'forEach', 'formatToParts', 'freeze', 'from', 'fromCharCode', 'fromCodePoint', 'fromEntries', 'fround', 'get', 'accessor', 'property', 'returns', 'the', 'Array', 'getCanonicalLocales', 'getDate', 'getDay', 'getFloat32', 'getFloat64', 'getFullYear', 'getHours', 'getInt16', 'getInt32', 'getInt8', 'getMilliseconds', 'getMinutes', 'getMonth', 'getNotifier', 'getOwnPropertyDescriptor', 'getOwnPropertyDescriptors', 'getOwnPropertyNames', 'getOwnPropertySymbols', 'getPrototypeOf', 'getSeconds', 'getTime', 'getTimezoneOffset', 'getUTCDate', 'getUTCDay', 'getUTCFullYear', 'getUTCHours', 'getUTCMilliseconds', 'getUTCMinutes', 'getUTCMonth', 'getUTCSeconds', 'getUint16', 'getUint32', 'getUint8', 'getVarDate', 'getYear', 'grow', 'has', 'hasOwnProperty', 'hypot', 'Indexed', 'collections', 'This', 'chapter', 'introduces', 'collections', 'of', 'data', 'which', 'are', 'ordered', 'by', 'an', 'index', 'This', 'includes', 'arrays', 'and', 'array'-'like', 'constructs', 'such', 'as', 'Array', 'objects', 'and', 'TypedArray', 'imports', 'imul', 'includes', 'indexOf', 'instantiate', 'instantiateStreaming', 'is', 'isArray', 'isExtensible', 'isFinite', 'isFrozen', 'isGenerator', 'isInteger', 'isLockFree', 'isNaN', 'isPrototypeOf', 'isSafeInteger', 'isSealed', 'isView', 'italics', 'join', 'keyFor', 'keys', 'lastIndexOf', 'link', 'load', 'localeCompare', 'log', 'log10', 'log1p', 'log2', 'map', 'match', 'max', 'min', 'move', 'next', 'normalize', 'notify', 'now', 'observe', 'of', 'or', 'ownKeys', 'padEnd', 'padStart', 'parse', 'parseFloat', 'parseInt', 'pop', 'pow', 'preventExtensions', 'propertyIsEnumerable', 'method', 'returns', 'a', 'new', 'Iterator', 'object', 'that', 'iterates', 'over', 'the', 'code', 'points', 'of', 'a', 'String', 'value', 'returning', 'each', 'code', 'point', 'as', 'a', 'String', 'method', 'retrieves', 'the', 'matches', 'when', 'matching', 'a', 'string', 'against', 'a', 'regular', 'method', 'replaces', 'some', 'or', 'all', 'matches', 'of', 'a', 'this', 'pattern', 'in', 'a', 'string', 'by', 'a', 'replacement', 'and', 'returns', 'the', 'result', 'of', 'the', 'replacement', 'as', 'a', 'new', 'The', 'replacement', 'can', 'be', 'a', 'string', 'or', 'a', 'function', 'to', 'be', 'called', 'for', 'each', 'method', 'executes', 'a', 'search', 'for', 'a', 'match', 'between', 'a', 'this', 'regular', 'expression', 'and', 'a', 'method', 'splits', 'a', 'String', 'object', 'into', 'an', 'array', 'of', 'strings', 'by', 'separating', 'the', 'string', 'into', 'method', 'converts', 'a', 'Date', 'object', 'to', 'a', 'primitive', 'method', 'converts', 'a', 'Symbol', 'object', 'to', 'a', 'primitive', 'push', 'quote', 'race', 'random', 'raw', 'reduce', 'reduceRight', 'reject', 'repeat', 'replace', 'resolve', 'resolvedOptions', 'return', 'reverse', 'revocable', 'round', 'ScriptEngine', 'seal', 'search', 'select', 'set', 'setDate', 'setFloat32', 'setFloat64', 'setFullYear', 'setHours', 'setInt16', 'setInt32', 'setInt8', 'setMilliseconds', 'setMinutes', 'setMonth', 'setPrototypeOf', 'setSeconds', 'setTime', 'setUTCDate', 'setUTCFullYear', 'setUTCHours', 'setUTCMilliseconds', 'setUTCMinutes', 'setUTCMonth', 'setUTCSeconds', 'setUint16', 'setUint32', 'setUint8', 'setYear', 'shift', 'sign', 'sin', 'sinh', 'slice', 'small', 'some', 'sort', 'splice', 'split', 'sqrt', 'startsWith', 'store', 'strike', 'stringify', 'sub', 'subarray', 'substr', 'substring', 'sup', 'supportedLocalesOf', 'tan', 'tanh', 'test', 'then', 'throw', 'toDateString', 'toExponential', 'toFixed', 'toGMTString', 'toISOString', 'toInteger', 'toJSON', 'toLocaleDateString', 'toLocaleFormat', 'toLocaleLowerCase', 'toLocaleString', 'toLocaleTimeString', 'toLocaleUpperCase', 'toLowerCase', 'toPrecision', 'toSource', 'toString', 'toTimeString', 'toUTCString', 'toUpperCase', 'transfer', 'trim', 'trimEnd', 'trimStart', 'trunc', 'UTC', 'unobserve', 'unshift', 'unwatch', 'validate', 'valueOf', 'values', 'wait', 'watch', 'writeln', 'xor'];
    for(var i = 0, len = jsBuiltInFuncs.length; i < len; i++) {
        protectedMap[jsBuiltInFuncs[i]] = true;
    }

    // js保留关键字
    var jsKeyWords = ['abstract', 'arguments', 'boolean', 'break', 'byte', 'case', 'catch', 'char', 'class', 'const', 'continue', 'debugger', 'default', 'delete', 'do', 'double', 'else', 'enum', 'eval', 'export', 'extends', 'false', 'final', 'finally', 'float', 'for', 'function', 'goto', 'if', 'implements', 'import', 'in', 'instanceof', 'int', 'interface', 'let', 'long', 'native', 'new', 'null', 'package', 'private', 'protected', 'public', 'return', 'short', 'static', 'super', 'switch', 'synchronized', 'this', 'throw', 'throws', 'transient', 'true', 'try', 'typeof', 'var', 'void', 'volatile', 'while', 'with', 'yield', 'Array', 'Date', 'eval', 'function', 'hasOwnProperty', 'Infinity', 'isFinite', 'isNaN', 'isPrototypeOf', 'length', 'Math', 'NaN', 'name', 'Number', 'Object', 'prototype', 'String', 'toString', 'undefined', 'valueOf', 'getClass', 'java', 'JavaArray', 'javaClass', 'JavaObject', 'JavaPackage', 'alert', 'all', 'anchor', 'anchors', 'area', 'assign', 'blur', 'button', 'checkbox', 'clearInterval', 'clearTimeout', 'clientInformation', 'close', 'closed', 'confirm', 'constructor', 'crypto', 'decodeURI', 'decodeURIComponent', 'defaultStatus', 'document', 'element', 'elements', 'embed', 'embeds', 'encodeURI', 'encodeURIComponent', 'escape', 'event', 'fileUpload', 'focus', 'form', 'forms', 'frame', 'innerHeight', 'innerWidth', 'layer', 'layers', 'link', 'location', 'mimeTypes', 'navigate', 'navigator', 'frames', 'frameRate', 'hidden', 'history', 'image', 'images', 'offscreenBuffering', 'open', 'opener', 'option', 'outerHeight', 'outerWidth', 'packages', 'pageXOffset', 'pageYOffset', 'parent', 'parseFloat', 'parseInt', 'password', 'pkcs11', 'plugin', 'prompt', 'propertyIsEnum', 'radio', 'reset', 'screenX', 'screenY', 'scroll', 'secure', 'select', 'self', 'setInterval', 'setTimeout', 'status', 'submit', 'taint', 'text', 'textarea', 'top', 'unescape', 'untaint', 'window', 'onblur', 'onclick', 'onerror', 'onfocus', 'onkeydown', 'onkeypress', 'onkeyup', 'onmouseover', 'onload', 'onmouseup', 'onmousedown', 'onsubmit'];
    for(var i = 0, len = jsKeyWords.length; i < len; i++) {
        protectedMap[jsKeyWords[i]] = true;
    }

    // window属性接口
    var windowRelatives = ['applicationCache', 'caches', 'closed', 'console', 'controllers', 'crypto', 'customElements', 'defaultStatus', 'devicePixelRatio', 'dialogArguments', 'directories', 'document', 'frameElement', 'frames', 'fullScreen', 'history', 'indexedDB', 'innerHeight', 'innerWidth', 'isSecureContext', 'length', 'localStorage', 'location', 'locationbar', 'menubar', 'mozAnimationStartTime', 'mozInnerScreenX', 'mozInnerScreenY', 'mozPaintCount', 'name', 'navigator', 'onabort', 'onafterprint', 'onanimationcancel', 'onanimationend', 'onanimationiteration', 'onappinstalled', 'onauxclick', 'onbeforeinstallprompt', 'onbeforeprint', 'onbeforeunload', 'onblur', 'onchange', 'onclick', 'onclose', 'oncontextmenu', 'ondblclick', 'ondevicelight', 'ondevicemotion', 'ondeviceorientation', 'ondeviceorientationabsolute', 'ondeviceproximity', 'ondragdrop', 'onerror', 'onfocus', 'ongamepadconnected', 'ongamepaddisconnected', 'ongotpointercapture', 'onhashchange', 'oninput', 'onkeydown', 'onkeypress', 'onkeyup', 'onlanguagechange', 'onload', 'onloadend', 'onloadstart', 'onlostpointercapture', 'onmessage', 'onmessageerror', 'onmousedown', 'onmousemove', 'onmouseout', 'onmouseover', 'onmouseup', 'onmozbeforepaint', 'onpaint', 'onpointercancel', 'onpointerdown', 'onpointerenter', 'onpointerleave', 'onpointermove', 'onpointerout', 'onpointerover', 'onpointerup', 'onpopstate', 'onrejectionhandled', 'onreset', 'onresize', 'onscroll', 'onselect', 'onselectionchange', 'onselectstart', 'onstorage', 'onsubmit', 'ontouchcancel', 'ontouchstart', 'ontransitioncancel', 'ontransitionend', 'onunhandledrejection', 'onunload', 'onuserproximity', 'onvrdisplayactivate', 'onvrdisplayblur', 'onvrdisplayconnect', 'onvrdisplaydeactivate', 'onvrdisplaydisconnect', 'onvrdisplayfocus', 'onvrdisplaypresentchange', 'onwheel', 'opener', 'origin', 'outerHeight', 'outerWidth', 'pageYOffset', 'parent', 'performance', 'personalbar', 'pkcs11', 'screen', 'screenLeft', 'screenTop', 'screenX', 'screenY', 'scrollbars', 'scrollMaxX', 'scrollMaxY', 'scrollX', 'scrollY', 'self', 'sessionStorage', 'sidebar', 'speechSynthesis', 'status', 'statusbar', 'toolbar', 'top', 'visualViewport', 'window', 'alert', 'atob', 'back', 'blur', 'btoa', 'cancelAnimationFrame', 'cancelIdleCallback', 'captureEvents', 'clearImmediate', 'clearInterval', 'clearTimeout', 'close', 'confirm', 'convertPointFromNodeToPage', 'convertPointFromPageToNode', 'createImageBitmap', 'dump', 'event', 'fetch', 'find', 'focus', 'forward', 'getAttention', 'getComputedStyle', 'getDefaultComputedStyle', 'getSelection', 'home', 'matchMedia', 'minimize', 'moveBy', 'moveTo', 'open', 'openDialog', 'postMessage', 'print', 'prompt', 'releaseEvents', 'requestAnimationFrame', 'requestFileSystem', 'requestIdleCallback', 'resizeBy', 'resizeTo', 'restore', 'routeEvent', 'scroll', 'scrollBy', 'scrollByLines', 'scrollByPages', 'scrollTo', 'setCursor', 'setImmediate', 'setInterval', 'setTimeout', 'showModalDialog', 'sizeToContent', 'stop', 'updateCommands'];
    for(var i = 0, len = windowRelatives.length; i < len; i++) {
        protectedMap[windowRelatives[i]] = true;
    }

    // Navigator: http://www.w3school.com.cn/jsref/dom_obj_navigator.asp
    var navigatorRelatives = ['appCodeName', 'appMinorVersion', 'appName', 'appVersion', 'browserLanguage', 'cookieEnabled', 'cpuClass', 'onLine', 'platform', 'systemLanguage', 'userAgent', 'userLanguage', 'Navigator', 'javaEnabled', 'taintEnabled'];
    for(var i = 0, len = navigatorRelatives.length; i < len; i++) {
        protectedMap[navigatorRelatives[i]] = true;
    }

    // Screen: http://www.w3school.com.cn/jsref/dom_obj_screen.asp
    var screenRelatives = ['availHeight', 'availWidth', 'bufferDepth', 'colorDepth', 'deviceXDPI', 'deviceYDPI', 'fontSmoothingEnabled', 'height', 'logicalXDPI', 'logicalYDPI', 'pixelDepth', 'updateInterval', 'width'];
    for(var i = 0, len = screenRelatives.length; i < len; i++) {
        protectedMap[screenRelatives[i]] = true;
    }

    // History: http://www.w3school.com.cn/jsref/dom_obj_history.asp
    var hitoryRelatives = ['length', 'History', 'back', 'forward', 'go'];
    for(var i = 0, len = hitoryRelatives.length; i < len; i++) {
        protectedMap[hitoryRelatives[i]] = true;
    }

    // Location: http://www.w3school.com.cn/jsref/dom_obj_location.asp
    var locationRelatives = ['hash', 'host', 'hostname', 'href', 'pathname', 'port', 'protocol', 'search', 'Location', 'assign', 'reload', 'replace'];
    for(var i = 0, len = locationRelatives.length; i < len; i++) {
        protectedMap[locationRelatives[i]] = true;
    }


    // HTML5
    // Canvas: http://www.w3school.com.cn/tags/html_ref_canvas.asp
    var canvasRelatives = ['fillStyle', 'strokeStyle', 'shadowColor', 'shadowBlur', 'shadowOffsetX', 'shadowOffsetY', 'createLinearGradient', 'createPattern', 'createRadialGradient', 'addColorStop', 'lineCap', 'lineJoin', 'lineWidth', 'miterLimit', 'rect', 'fillRect', 'strokeRect', 'clearRect', 'fill', 'stroke', 'beginPath', 'moveTo', 'closePath', 'lineTo', 'clip', 'quadraticCurveTo', 'bezierCurveTo', 'arc', 'arcTo', 'isPointInPath', 'scale', 'rotate', 'translate', 'transform', 'setTransform', 'font', 'textAlign', 'textBaseline', 'fillText', 'strokeText', 'measureText', 'drawImage', 'width', 'height', 'data', 'createImageData', 'getImageData', 'putImageData', 'globalAlpha', 'globalCompositeOperation', 'save', 'restore', 'createEvent', 'getContext', 'toDataURL'];    
    for(var i = 0, len = canvasRelatives.length; i < len; i++) {
        protectedMap[canvasRelatives[i]] = true;
    }

    // CanvasRenderingContext2D: http://www.w3school.com.cn/jsref/dom_obj_canvasrenderingcontext2d.asp
    var crc2dRelatives = ['CanvasRenderingContext2D', 'canvas', 'fillStyle', 'globalAlpha', 'globalCompositeOperation', 'lineCap', 'lineJoin', 'lineWidth', 'miterLimit', 'shadowBlur', 'shadowColor', 'shadowOffsetX', 'strokeStyle', 'arc', 'arcTo', 'beginPath', 'bezierCurveTo', 'clearRect', 'clip', 'closePath', 'createLinearGradient', 'createPattern', 'createRadialGradient', 'drawImage', 'fill', 'fillRect', 'lineTo', 'moveTo', 'quadraticCurveTo', 'rect', 'restore', 'rotate', 'save', 'scale', 'stroke', 'strokeRect', 'translate'];
    for(var i = 0, len = crc2dRelatives.length; i < len; i++) {
        protectedMap[crc2dRelatives[i]] = true;
    }

    // Audio/Video: http://www.w3school.com.cn/tags/html_ref_audio_video_dom.asp
    var avRelatives = ['addTextTrack', 'canPlayType', 'load', 'play', 'pause', 'HTML', 'audioTracks', 'autoplay', 'buffered', 'controller', 'controls', 'crossOrigin', 'currentSrc', 'currentTime', 'defaultMuted', 'defaultPlaybackRate', 'duration', 'ended', 'error', 'loop', 'mediaGroup', 'muted', 'networkState', 'paused', 'playbackRate', 'played', 'preload', 'readyState', 'seekable', 'seeking', 'src', 'startDate', 'textTracks', 'videoTracks', 'volume', 'abort', 'canplay', 'canplaythrough', 'durationchange', 'emptied', 'ended', 'error', 'loadeddata', 'loadedmetadata', 'loadstart', 'pause', 'play', 'playing', 'progress', 'ratechange', 'seeked', 'seeking', 'stalled', 'suspend', 'timeupdate', 'volumechange', 'waiting'];
    for(var i = 0, len = avRelatives.length; i < len; i++) {
        protectedMap[avRelatives[i]] = true;
    }

    // Events: http://www.w3school.com.cn/tags/html_ref_eventattributes.asp
    var eventRelatives = ['onafterprint', 'onbeforeprint', 'onbeforeunload', 'onerror', 'onhaschange', 'onload', 'onmessage', 'onoffline', 'ononline', 'onpagehide', 'onpageshow', 'onpopstate', 'onredo', 'onresize', 'onstorage', 'onundo', 'onunload', 'Form', 'onblur', 'onchange', 'oncontextmenu', 'onfocus', 'onformchange', 'onforminput', 'oninput', 'oninvalid', 'onreset', 'onselect', 'onsubmit', 'Keyboard', 'onkeydown', 'onkeypress', 'onkeyup', 'Mouse', 'onclick', 'ondblclick', 'ondrag', 'ondragend', 'ondragenter', 'ondragleave', 'ondragover', 'ondragstart', 'ondrop', 'onmousedown', 'onmousemove', 'onmouseout', 'onmouseover', 'onmouseup', 'onmousewheel', 'onscroll', 'Media', 'onabort', 'oncanplay', 'oncanplaythrough', 'ondurationchange', 'onemptied', 'onended', 'onerror', 'onloadeddata', 'onloadedmetadata', 'onloadstart', 'onpause', 'onplay', 'onplaying', 'onprogress', 'onratechange', 'onreadystatechange', 'onseeked', 'onseeking', 'onstalled', 'onsuspend', 'ontimeupdate', 'onvolumechange', 'onwaiting'];
    for(var i = 0, len = eventRelatives.length; i < len; i++) {
        protectedMap[eventRelatives[i]] = true;
    }

    // DOM: 
    var domRelatives = ['all', 'anchors', 'applets', 'forms', 'images', 'links', 'body', 'cookie', 'domain', 'lastModified', 'referrer', 'title', 'URL', 'close', 'getElementById', 'getElementsByName', 'getElementsByTagName', 'open', 'write', 'writeln', 'accessKey', 'appendChild', 'attributes', 'childNodes', 'className', 'clientHeight', 'clientWidth', 'cloneNode', 'compareDocumentPosition', 'contentEditable', 'dir', 'firstChild', 'getAttribute', 'getAttributeNode', 'getElementsByTagName', 'getFeature', 'getUserData', 'hasAttribute', 'hasAttributes', 'hasChildNodes', 'id', 'innerHTML', 'insertBefore', 'isContentEditable', 'isDefaultNamespace', 'isEqualNode', 'isSameNode', 'isSupported', 'lang', 'lastChild', 'namespaceURI', 'nextSibling', 'nodeName', 'nodeType', 'nodeValue', 'normalize', 'offsetHeight', 'offsetWidth', 'offsetLeft', 'offsetParent', 'offsetTop', 'ownerDocument', 'parentNode', 'previousSibling', 'removeAttribute', 'removeAttributeNode', 'removeChild', 'replaceChild', 'scrollHeight', 'scrollLeft', 'scrollTop', 'scrollWidth', 'setAttribute', 'setAttributeNode', 'setIdAttribute', 'setIdAttributeNode', 'setUserData', 'style', 'tabIndex', 'tagName', 'textContent', 'title', 'toString', 'nodelist', 'nodelist', 'isId', 'name', 'value', 'specified', 'nodemap', 'nodemap', 'nodemap', 'nodemap', 'nodemap', 'appendChild', 'attributes', 'baseURI', 'childNodes', 'cloneNode', 'firstChild', 'hasAttributes', 'hasChildNodes', 'insertBefore', 'isEqualNode', 'isSameNode', 'isSupported', 'lastChild', 'nextSibling', 'nodeName', 'nodeType', 'nodeValue', 'normalize', 'ownerDocument', 'ownerElement', 'parentNode', 'previousSibling', 'removeChild', 'replaceChild', 'textContent', 'onabort', 'onblur', 'onchange', 'onclick', 'ondblclick', 'onerror', 'onfocus', 'onkeydown', 'onkeypress', 'onkeyup', 'onload', 'onmousedown', 'onmousemove', 'onmouseout', 'onmouseover', 'onmouseup', 'onreset', 'onresize', 'onselect', 'onsubmit', 'onunload', 'altKey', 'button', 'clientX', 'clientY', 'ctrlKey', 'metaKey', 'relatedTarget', 'screenX', 'screenY', 'shiftKey', 'cancelBubble', 'fromElement', 'keyCode', 'offsetX', 'returnValue', 'srcElement', 'toElement', 'x', 'bubbles', 'cancelable', 'currentTarget', 'eventPhase', 'target', 'timeStamp', 'type', 'initEvent', 'preventDefault', 'stopPropagation'];
    for(var i = 0, len = domRelatives.length; i < len; i++) {
        protectedMap[domRelatives[i]] = true;
    }

    // Html5 Attributes: http://www.w3school.com.cn/tags/html_ref_standardattributes.asp
    var h5AtrRelatives = ['accesskey', 'class', 'contenteditable', 'contextmenu', 'data', 'dir', 'draggable', 'dropzone', 'hidden', 'id', 'lang', 'spellcheck', 'style', 'tabindex', 'title', 'translate'];
    for(var i = 0, len = h5AtrRelatives.length; i < len; i++) {
        protectedMap[h5AtrRelatives[i]] = true;
    }

    // WebGL: https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API
    var webglRelatives = ['WebGLRenderingContext', 'WebGL2RenderingContext', 'WebGLActiveInfo', 'WebGLBuffer', 'WebGLContextEvent', 'WebGLFramebuffer', 'WebGLProgram', 'WebGLQuery', 'WebGLRenderbuffer', 'WebGLSampler', 'WebGLShader', 'WebGLShaderPrecisionFormat', 'WebGLSync', 'WebGLTexture', 'WebGLTransformFeedback', 'WebGLUniformLocation', 'WebGLVertexArrayObject', 'canvas', 'drawingBufferHeight', 'drawingBufferWidth', 'activeTexture', 'attachShader', 'bindAttribLocation', 'bindBuffer', 'bindFramebuffer', 'bindRenderbuffer', 'bindTexture', 'blendColor', 'blendEquation', 'blendEquationSeparate', 'blendFunc', 'blendFuncSeparate', 'bufferData', 'bufferSubData', 'checkFramebufferStatus', 'clear', 'clearColor', 'clearDepth', 'clearStencil', 'colorMask', 'commit', 'compileShader', 'compressedTexImage2D', 'compressedTexImage3D', 'compressedTexSubImage2D', 'copyTexImage2D', 'copyTexSubImage2D', 'createBuffer', 'createFramebuffer', 'createProgram', 'createRenderbuffer', 'createShader', 'createTexture', 'cullFace', 'deleteBuffer', 'deleteFramebuffer', 'deleteProgram', 'deleteRenderbuffer', 'deleteShader', 'deleteTexture', 'depthFunc', 'depthMask', 'depthRange', 'detachShader', 'disable', 'disableVertexAttribArray', 'drawArrays', 'drawElements', 'enable', 'enableVertexAttribArray', 'finish', 'flush', 'framebufferRenderbuffer', 'framebufferTexture2D', 'frontFace', 'generateMipmap', 'getActiveAttrib', 'getActiveUniform', 'getAttachedShaders', 'getAttribLocation', 'getBufferParameter', 'getContextAttributes', 'getError', 'getExtension', 'getFramebufferAttachmentParameter', 'getParameter', 'getProgramInfoLog', 'getProgramParameter', 'getRenderbufferParameter', 'getShaderInfoLog', 'getShaderParameter', 'getShaderPrecisionFormat', 'getShaderSource', 'getSupportedExtensions', 'getTexParameter', 'getUniform', 'getUniformLocation', 'getVertexAttrib', 'getVertexAttribOffset', 'hint', 'isBuffer', 'isContextLost', 'isEnabled', 'isFramebuffer', 'isProgram', 'isRenderbuffer', 'isShader', 'isTexture', 'lineWidth', 'linkProgram', 'pixelStorei', 'polygonOffset', 'readPixels', 'renderbufferStorage', 'sampleCoverage', 'scissor', 'shaderSource', 'stencilFunc', 'stencilFuncSeparate', 'stencilMask', 'stencilMaskSeparate', 'stencilOp', 'stencilOpSeparate', 'texImage2D', 'texParameterf', 'texParameteri', 'texSubImage2D', 'uniform1f', 'uniform1fv', 'uniform1i', 'uniform1iv', 'uniform2f', 'uniform2fv', 'uniform2i', 'uniform2iv', 'uniform3f', 'uniform3fv', 'uniform3i', 'uniform3iv', 'uniform4f', 'uniform4fv', 'uniform4i', 'uniform4iv', 'uniformMatrix2fv', 'uniformMatrix3fv', 'uniformMatrix4fv', 'useProgram', 'validateProgram', 'vertexAttrib1f', 'vertexAttrib2f', 'vertexAttrib3f', 'vertexAttrib4f', 'vertexAttrib1fv', 'vertexAttrib2fv', 'vertexAttrib3fv', 'vertexAttrib4fv', 'vertexAttribPointer', 'viewport', 'webglcontextlost', 'webglcontextrestored', 'webglcontextcreationerror', 'Related', 'pages', 'for', 'WebGL', 'ANGLE_instanced_arrays', 'EXT_blend_minmax', 'EXT_color_buffer_half_float', 'EXT_disjoint_timer_query', 'EXT_frag_depth', 'EXT_sRGB', 'EXT_shader_texture_lod', 'EXT_texture_filter_anisotropic', 'OES_element_index_uint', 'OES_standard_derivatives', 'OES_texture_float', 'OES_texture_float_linear', 'OES_texture_half_float', 'OES_texture_half_float_linear', 'OES_vertex_array_object', 'WEBGL_color_buffer_float', 'WEBGL_compressed_texture_atc', 'WEBGL_compressed_texture_etc1', 'WEBGL_compressed_texture_pvrtc', 'WEBGL_compressed_texture_s3tc', 'WEBGL_compressed_texture_s3tc_srgb', 'WEBGL_debug_renderer_info', 'WEBGL_debug_shaders', 'WEBGL_depth_texture', 'WEBGL_draw_buffers', 'WEBGL_lose_context', 'WebGL2RenderingContext', 'WebGLActiveInfo', 'WebGLBuffer', 'WebGLContextEvent', 'WebGLFramebuffer', 'WebGLObject', 'WebGLProgram', 'WebGLQuery', 'WebGLRenderbuffer', 'WebGLSampler', 'WebGLShader', 'WebGLShaderPrecisionFormat', 'WebGLSync', 'WebGLTexture', 'WebGLTransformFeedback', 'WebGLUniformLocation', 'WebGLVertexArrayObject', 'beginQuery', 'beginTransformFeedback', 'bindBufferBase', 'bindBufferRange', 'bindSampler', 'bindTransformFeedback', 'bindVertexArray', 'blitFramebuffer', 'clearBufferf', 'clearBufferi', 'clearBufferu', 'clearBufferv', 'clientWaitSync', 'compressedTexSubImage3D', 'copyBufferSubData', 'copyTexSubImage3D', 'createQuery', 'createSampler', 'createTransformFeedback', 'createVertexArray', 'deleteQuery', 'deleteSampler', 'deleteSync', 'deleteTransformFeedback', 'deleteVertexArray', 'drawArraysInstanced', 'drawBuffers', 'drawElementsInstanced', 'drawRangeElements', 'endQuery', 'endTransformFeedback', 'fenceSync', 'framebufferTextureLayer', 'getActiveUniformBlockName', 'getActiveUniformBlockParameter', 'getActiveUniforms', 'getBufferSubData', 'getFragDataLocation', 'getIndexedParameter', 'getInternalformatParameter', 'getQuery', 'getQueryParameter', 'getSamplerParameter', 'getSyncParameter', 'getTransformFeedbackVarying', 'getUniformBlockIndex', 'getUniformIndices', 'invalidateFramebuffer', 'invalidateSubFramebuffer', 'isQuery', 'isSampler', 'isSync', 'isTransformFeedback', 'isVertexArray', 'pauseTransformFeedback', 'readBuffer', 'renderbufferStorageMultisample', 'resumeTransformFeedback', 'samplerParameteri', 'samplerParameterf', 'texImage3D', 'texStorage2D', 'texStorage3D', 'texSubImage3D', 'transformFeedbackVaryings', 'uniform1ui', 'uniform2ui', 'uniform3ui', 'uniform4ui', 'uniform1fv', 'uniform2fv', 'uniform3fv', 'uniform4fv', 'uniform1iv', 'uniform2iv', 'uniform3iv', 'uniform4iv', 'uniform1uiv', 'uniform2uiv', 'uniform3uiv', 'uniform4uiv', 'uniformBlockBinding', 'uniformMatrix2fv', 'uniformMatrix3x2fv', 'uniformMatrix4x2fv', 'uniformMatrix2x3fv', 'uniformMatrix3fv', 'uniformMatrix4x3fv', 'uniformMatrix2x4fv', 'uniformMatrix3x4fv', 'uniformMatrix4fv', 'vertexAttribDivisor', 'vertexAttribI4i', 'vertexAttribI4ui', 'vertexAttribI4iv', 'vertexAttribI4uiv', 'vertexAttribIPointer', 'waitSync', 'name', 'size', 'type', 'statusMessage', 'precision', 'rangeMax', 'rangeMin'];
    for(var i = 0, len = webglRelatives.length; i < len; i++) {
        protectedMap[webglRelatives[i]] = true;
    }

    // XMLHttpRequest: https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest
    var xmlHttpReqRelatives = ['XMLHttpRequest', 'channel', 'mozAnon', 'mozBackgroundRequest', 'mozResponseArrayBuffer', 'mozSystem', 'multipart', 'onreadystatechange', 'readyState', 'response', 'responseText', 'responseType', 'responseURL', 'responseXML', 'status', 'statusText', 'timeout', 'upload', 'withCredentials', 'abort', 'getAllResponseHeaders', 'getResponseHeader', 'open', 'openRequest', 'overrideMimeType', 'send', 'sendAsBinary', 'setRequestHeader', 'XMLHttpRequestEventTarget', 'EventTarget', 'loadstart', 'progress', 'abort', 'error', 'load', 'timeout', 'loadend', 'readystatechange'];
    for(var i = 0, len = xmlHttpReqRelatives.length; i < len; i++) {
        protectedMap[xmlHttpReqRelatives[i]] = true;
    }

    // Console: http://www.runoob.com/jsref/obj-console.html
    var consoleRelatives = ['assert', 'clear', 'count', 'error', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log', 'table', 'time', 'timeEnd', 'trace', 'warn'];
    for(var i = 0, len = consoleRelatives.length; i < len; i++) {
        protectedMap[consoleRelatives[i]] = true;
    }

    // Storage: https://developer.mozilla.org/zh-CN/docs/Web/API/Storage
    var storageRelatives = ['length', 'clear', 'getItem', 'key', 'removeItem', 'setItem'];
    for(var i = 0, len = storageRelatives.length; i < len; i++) {
        protectedMap[storageRelatives[i]] = true;
    }

    // RegExp: https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/RegExp
    var regExpRelatives = ['length', 'clear', 'getItem', 'key', 'removeItem', 'setItem', '$1', '$2', '$3', '$4', '$5', '$6', '$7', '$8', '$9', 'input', 'lastMatch', 'lastParen', 'leftContext', 'flags', 'global', 'ignoreCase', 'multiline', 'source', 'sticky', 'unicode', 'rightContext', 'species', 'lastIndex'];
    for(var i = 0, len = regExpRelatives.length; i < len; i++) {
        protectedMap[regExpRelatives[i]] = true;
    }

    // Worker: https://developer.mozilla.org/zh-CN/docs/Web/API/Worker
    var workerRelatives = ['Worker', 'onerror', 'onmessage', 'onmessageerror', 'postMessage', 'terminate'];
    for(var i = 0, len = workerRelatives.length; i < len; i++) {
        protectedMap[workerRelatives[i]] = true;
    }

    // URL: https://developer.mozilla.org/zh-CN/docs/Web/API/URL
    var urlRelatives = ['URL', 'origin', 'searchParams', '', 'createObjectURL', 'revokeObjectURL'];
    for(var i = 0, len = urlRelatives.length; i < len; i++) {
        protectedMap[urlRelatives[i]] = true;
    }
        
    // 运算符优先级
    var pv = 0;
    const operatorPriorityMap = {};
    setPriority(['( … )'], pv++);
    setPriority(['… . …', '… [ … ]', 'new … ( … )', '… ( … )'], pv++);
    setPriority(['new …'], pv++);
    setPriority(['… ++', '… --'], pv++);
    setPriority(['! …', '~ …', '+ …', '- …', '++ …', '-- …', 'typeof …', 'void …', 'delete …', 'await …'], pv++);
    setPriority(['… ** …'], pv++);
    setPriority(['… * …', '… / …', '… % …'], pv++);
    setPriority(['… + …', '… - …'], pv++);
    setPriority(['… << …', '… >> …', '… >>> …'], pv++);
    setPriority(['… < …', '… <= …', '… > …', '… >= …', '… in …', '… instanceof …'], pv++);
    setPriority(['… == …', '… != …', '… === …', '… !== …'], pv++);
    setPriority(['… & …'], pv++);
    setPriority(['… ^ …'], pv++);
    setPriority(['… | …'], pv++);
    setPriority(['… && …'], pv++);
    setPriority(['… || …'], pv++);
    setPriority(['… ? … : …'], pv++);
    setPriority(['… = …', '… += …', '… -= …', '… *= …', '… /= …', '… %= …', '… <<= …', '… >>= …', '… >>>= …', '… &= …', '… ^= …', '… |= …'], pv++);
    setPriority(['yield …', 'yield* …'], pv++);
    setPriority(['...'], pv++);
    setPriority(['… , …'], pv++);
        
    function setPriority(keys, value) {
        for(var i = 0, len = keys.length; i < len; i++) {
            operatorPriorityMap[keys[i]] = value;
        }
    }

    // 读取laya资源中使用到的字段进行保护
    var st = (new Date()).getTime();
    console.log('fetching keywords from laya res files...');    
    var layakeys = [];
    var skipLayaTypes = ['.lm', '.lani', '.png', '.jpg'];  // json类型的文件包括.lh .ls .lav .lmat
    var filePath = path.resolve(layaResPath);
    // readLayaResDir(filePath);
    var et = (new Date()).getTime();
    console.log(layakeys.length + ' keywords from laya res files finished, ' + (et - st) + 'ms costed. ');

    function readLayaResDir(filePath){
        var files = fs.readdirSync(filePath);
        
        //遍历读取到的文件列表
        files.forEach(function(filename){
            //获取当前文件的绝对路径
            var filedir = path.join(filePath, filename);
            //根据文件路径获取文件信息，返回一个fs.Stats对象
            var stats = fs.statSync(filedir);
            if(stats.isFile()){
                var extname = path.extname(filename).toLowerCase();
                if(skipLayaTypes.indexOf(extname) < 0) {
　　　　　　　　　　// 读取文件内容
                    var content = fs.readFileSync(filedir, 'utf-8');
                    var fdata = JSON.parse(content);
                    fetchLayaKeys(fdata);
                }                        
            } else if(stats.isDirectory()){
                readLayaResDir(filedir);//递归，如果是文件夹，就继续遍历该文件夹下面的文件
            }
        });
    }

    function fetchLayaKeys(fdata) {
        for(var key in fdata) {
            if(!protectedMap[key]) {
                protectedMap[key] = true;
                layakeys.push(key);
            }
            
            var sdata = fdata[key];
            if(sdata instanceof Object) {
                fetchLayaKeys(sdata);
            }
        }
    }
    
    // 读取配置结构中的字段进行保护，因二级结构不会被编译成js
    st = (new Date()).getTime();
    console.log('fetching property from cfg src files...');
    var cfgSrcPath = path.resolve(projPath + 'src/automatic/cfgs/');
    var cfgClassNameMap = {};
    var savedCfgWords = [];
    console.log(savedCfgWords.length + ' cfg words saved.');
    var et = (new Date()).getTime();
    console.log('fetching property from cfg src files finished, ' + (et - st) + 'ms costed. ');
        
    const noBraceTypes = ['MemberExpression', 'ThisExpression', 'Identifier'];
    const protectedClassMaxLv = 6; // 1个protected class标记最多上浮6次
    
    var astArr = [];
    var uglyMap = {};
    var uglyPool = [];
    var noUglyMap = {};
    var formatNewLine = '';
    var formatBlanks = '';
    if(!donotFormat) {
        formatNewLine = '\n';
        formatBlanks = '    ';
    }
    var seperateLine = '----------';
    
    // 读取混淆记录，分包的情况下需要保证不同的包混淆一致
    var recordMap = {};
    if(useUglyRecord) {
        var recordContent = fs.readFileSync(workFolder + 'lastConfusion.txt', 'utf8');
        var contentArr = recordContent.split(seperateLine);
        // 先读取混淆记录
        var rline = contentArr[0].split(/\n+/);
        for(var i = 0, len = rline.length; i < len; i++) {
            var rarr = rline[i].split(/,\s*/);
            // console.log('read record: ' + rarr[0] + '->' +rarr[1]);
            uglyMap[rarr[0]] = rarr[1];
            recordMap[rarr[1]] = true;
        }
        // 读取保护记录
        if(contentArr.length > 1) {
            var parr = contentArr[1].replace('\n', '').split(',');
            for(var i = 0, len = parr.length; i < len; i++) {
                protectedMap[parr[i]] = true;
            }
        }            
    } 
        
    st = (new Date()).getTime();
    console.log('building ugly pool...');
    buildUglyPool();
    et = (new Date()).getTime();
    console.log('building ugly pool finished, ' + (et - st) + 'ms costed. ');
    
    for(var i = 0, len = rootJsPaths.length; i < len; i++) {        
        var rootJsPath = rootJsPaths[i];
        fs.copyFileSync(rootJsPath, workFolder + i + '.js');
        console.log('parsing syntax tree: ' + rootJsPath + '...');
        st = et;
        var data = fs.readFileSync(rootJsPath, 'utf8');        
        var ast = esprima.parseScript(data);
        astArr.push(ast);
        et = (new Date()).getTime();
        console.log('parsing syntax tree finished, ' + (et - st) + 'ms costed. ');
        
        console.log('modifying syntax tree...');
        st = et;
        processAST(ast);
        et = (new Date()).getTime();
        console.log('modifying syntax tree finished, ' + (et - st) + 'ms costed. ');
        
        console.log('marking laya classes...');
        st = et;
        markLayaClasses(ast);
        et = (new Date()).getTime();
        console.log('laya classes marked, ' + (et - st) + 'ms costed. ');
    }
        
    for(var i = 0, len = rootJsPaths.length; i < len; i++) {        
        var rootJsPath = rootJsPaths[i];
        st = et;
        console.log('building ugly code....');
        var ast = astArr[i];
        var uglyCode = codeFromAST(ast);
        et = (new Date()).getTime();
        console.log('ugly code generated, ' + (et - st) + 'ms costed. ');
        
        st = et;
        var saveJsPath = rootJsPath;
        if(!replaceIt) {
            saveJsPath = rootJsPath.replace(/\.js$/, '.ugly.js');
        }
        console.log('saving ugly code as ' + saveJsPath + '....');        
        fs.writeFileSync(saveJsPath, uglyCode);
        fs.copyFileSync(saveJsPath, workFolder + i + '.ugly.js');
        
        et = (new Date()).getTime();
        console.log('ugly code saved, ' + (et - st) + 'ms costed. ');
        
        //// 分析丑代码语法树
        // console.log('parsing ugly syntax tree...');
        // st = et;
        // var uglyAst = esprima.parseScript(uglyCode);
        // et = (new Date()).getTime();
        // console.log('parsing ugly syntax tree finished, ' + (et - st) + 'ms costed. ');
        
        //// 对比两棵语法树是否相同
        // console.log('comparing two syntax tree...');
        // st = et;
        // compareAST(ast, uglyAst);
        // et = (new Date()).getTime();
        // console.log('comparing syntax tree finished, ' + (et - st) + 'ms costed. ');
    }
        
    // 保存混淆记录
    console.log('saving confusion record...');
    st = et;
    var confusionContent = '';
    for(var key in uglyMap) {
        confusionContent += key + ', ' + uglyMap[key] + '\n';
    }
    confusionContent += seperateLine + '\n';
    for(var key in protectedMap) {
        confusionContent += key + ',';
    }
    for(var key in noUglyMap) {
        confusionContent += key + ',';
    }
    var confusionRecordName = workFolder + 'confusion' + st + '.txt';
    fs.writeFileSync(confusionRecordName, confusionContent);
    
    et = (new Date()).getTime();
    fs.copyFileSync(confusionRecordName, workFolder + 'lastConfusion.txt');
    console.log('confusion record saved, ' + (et - st) + 'ms costed. ');
    
    checkDisplayError();
    console.log('total cost ' + (et - startAt) + 'ms. ');
        
    function astToSimpleString(ast) {
        var str = '';
        if(ast instanceof Object) {
            for(var key in ast) {
                if(key.indexOf('__') != 0) {
                    str += key + ':' + astToSimpleString(ast[key]) + ';';
                }                
            }
        } else {
            str = '' + ast;
        }
        return str + '\n';
    }

    function markLayaClasses(ast) {
        for(var key in ast) {
            var sast = ast[key];
            if(sast instanceof Object) {
                if(ast.__protectedClass) {
                    sast.__protectedClass = ast.__protectedClass;
                }
                markLayaClasses(sast);
            }
        }
        if(ast.__protectedClass && ast.type == 'Identifier') {
            protectedMap[ast.name] = true;
        }
    }

    // 修改语法树
    function processAST(ast) {
        switch(ast.type) {
            case 'Node':
                processNode(ast);
                break;
            case 'Identifier':
                processIdentifier(ast);
                break;
            case 'Literal':
                processLiteral(ast);
                break;
            case 'RegExpLiteral':
                processRegExpLiteral(ast);
                break;
            case 'Program':
                processProgram(ast);
                break;
            case 'Function':
                processFunction(ast);
                break;
            case 'ExpressionStatement':
                processExpressionStatement(ast);
                break;
            case 'Directive':
                processDirective(ast);
                break;
            case 'BlockStatement':
                processBlockStatement(ast);
                break;
            case 'FunctionBody':
                processFunctionBody(ast);
                break;
            case 'EmptyStatement':
                processEmptyStatement(ast);
                break;
            case 'DebuggerStatement':
                processDebuggerStatement(ast);
                break;
            case 'WithStatement':
                processWithStatement(ast);
                break;
            case 'ReturnStatement':
                processReturnStatement(ast);
                break;
            case 'LabeledStatement':
                processLabeledStatement(ast);
                break;
            case 'BreakStatement':
                processBreakStatement(ast);
                break;
            case 'ContinueStatement':
                processContinueStatement(ast);
                break;
            case 'IfStatement':
                processIfStatement(ast);
                break;
            case 'SwitchStatement':
                processSwitchStatement(ast);
                break;
            case 'SwitchCase':
                processSwitchCase(ast);
                break;
            case 'ThrowStatement':
                processThrowStatement(ast);
                break;
            case 'TryStatement':
                processTryStatement(ast);
                break;
            case 'CatchClause':
                processCatchClause(ast);
                break;
            case 'WhileStatement':
                processWhileStatement(ast);
                break;
            case 'DoWhileStatement':
                processDoWhileStatement(ast);
                break;
            case 'ForStatement':
                processForStatement(ast);
                break;
            case 'ForInStatement':
                processForInStatement(ast);
                break;
            case 'FunctionDeclaration':
                processFunctionDecalaration(ast);
                break;
            case 'VariableDeclaration':
                processVariableDeclaration(ast);
                break;
            case 'VariableDeclarator':
                processVariableDeclarator(ast);
                break;
            case 'ThisExpression':
                processThisExpression(ast);
                break;
            case 'ArrayExpression':
                processArrayExpression(ast);
                break;
            case 'ObjectExpression':
                processObjectExpression(ast);
                break;
            case 'Property':
                processProperty(ast);
                break;
            case 'FunctionExpression':
                processFunctionExpression(ast);
                break;
            case 'UnaryExpression':
                processUnaryExpression(ast);
                break;
            case 'UnaryOperator':
                processUnaryOperator(ast);
                break;
            case 'UpdateExpression':
                processUpdateExpression(ast);
                break;
            case 'UpdateOperator':
                processUpdateOperator(ast);
                break;
            case 'BinaryExpression':
                processBinaryExpression(ast);
                break;
            case 'BinaryOperator':
                processBinaryOperator(ast);
                break;
            case 'AssignmentExpression':
                processAssignmentExpression(ast);
                break;
            case 'AssignmentOperator':
                processAssignmentOperator(ast);
                break;
            case 'LogicalExpression':
                processLogicalExpression(ast);
                break;
            case 'LogicalOperator':
                processLogicalOperator(ast);
                break;
            case 'MemberExpression':
                processMemberExpression(ast);
                break;
            case 'ConditionalExpression':
                processConditionalExpression(ast);
                break;
            case 'CallExpression':
                processCallExpression(ast);
                break;
            case 'NewExpression':
                processNewExpression(ast);
                break;
            case 'SequenceExpression':
                processSequenceExpression(ast);
                break;
            default:
                console.error('ERROR: unknown syntax type: ' + ast.type);
                break;
        }
    }

    function processNode(ast) {
        // do nothing...
    }

    function processIdentifier(ast) {
        // do nothing...
    }

    function processLiteral(ast) {
        if(typeof(ast.value) == 'string') {
            // 字符串类型的不予混淆            
            noUglyMap[ast.value] = true;
        }
    }

    function processRegExpLiteral(ast) {
        // do nothing...
    }

    function processProgram(pgm) {
        if(pgm.body instanceof Array) {
            for(var i in pgm.body) {
                processAST(pgm.body[i]);
            }
        } else {
            processAST(pgm.body);
        }
    }

    function processFunction(ast) {
        if(ast.id) {
            ast.id.__functionName = true;
            processAST(ast.id);
        }
        if(ast.params) {
            for(var i = 0, len = ast.params.length; i < len; i ++) {
                processAST(ast.params[i]);
            }
        }
        processAST(ast.body);
        if(ast.body.__protectedClass) {
            ast.__protectedClass = ast.body.__protectedClass;
            ast.__protectedClassLv = ast.body.__protectedClassLv + 1;
        }
    }

    function processExpressionStatement(ast) {
        processAST(ast.expression);
        if(ast.expression.__protectedClass) {
            ast.__protectedClass = ast.expression.__protectedClass;
            ast.__protectedClassLv = ast.expression.__protectedClassLv + 1;
        }
    }

    function processDirective(ast) {
        console.error('ERROR: processDirective');
        processLiteral(ast.expression);
    }

    function processBlockStatement(ast) {
        for(var i = 0, len = ast.body.length; i < len; i++) {
            var b = ast.body[i];
            processAST(b);
            if(b.__protectedClass && b.__protectedClassLv < protectedClassMaxLv) {
                ast.__protectedClass = b.__protectedClass;
                ast.__protectedClassLv = b.__protectedClassLv + 1;
            }
        }
    }

    function processFunctionBody(ast) {
        processAST(ast);
    }

    function processEmptyStatement(ast) {
        // do nothing...
    }

    function processDebuggerStatement(ast) {
        // do nothing...
    }

    function processWithStatement(ast) {
        processAST(ast.object);
        processAST(ast.body);
    }

    function processReturnStatement(ast) {
        ast.argument && processAST(ast.argument); 
    }

    function processLabeledStatement(ast) {
        processAST(ast.label);
        processAST(ast.body);
    }

    function processBreakStatement(ast) {
        ast.label && processAST(ast.label);
    }

    function processContinueStatement(ast) {
        ast.label && processAST(ast.label);
    }

    function processIfStatement(ast) {
        processAST(ast.test);
        processAST(ast.consequent);
        if(ast.alternate) {
            processAST(ast.alternate);
        }
    }

    function processSwitchStatement(ast) {
        processAST(ast.discriminant);
        for(var i = 0, len = ast.cases.length; i < len; i++) {
            processSwitchCase(ast.cases[i]);
        }
    }

    function processSwitchCase(ast) {
        ast.test && processAST(ast.test);
        for(var i = 0, len = ast.consequent.length; i < len; i++) {
            processAST(ast.consequent[i]);
        }
    }

    function processThrowStatement(ast) {
        processAST(ast.argument);
    }

    function processTryStatement(ast) {
        processBlockStatement(ast.block);
        ast.handler && processCatchClause(ast.handler);
        ast.finalizer && processBlockStatement(ast.finalizer);
    }

    function processCatchClause(ast) {
        processIdentifier(ast.param);
        processBlockStatement(ast.body);
    }

    function processWhileStatement(ast) {
        processAST(ast.test);
        processAST(ast.body);
    }

    function processDoWhileStatement(ast) {
        processAST(ast.body);
        processAST(ast.test);
    }

    function processForStatement(ast) {
        ast.init && processAST(ast.init);
        ast.test && processAST(ast.test);
        ast.update && processAST(ast.update);
        processAST(ast.body);
    }

    function processForInStatement(ast) {
        processAST(ast.left);
        processAST(ast.right);
        processAST(ast.body);
    }

    function processFunctionDecalaration(ast) {
        processFunction(ast);
    }

    function processVariableDeclaration(ast) {
        var protectedClasses = [];
        var protectedCnt = 0;
        var protectedClassLv = 0;
        for(var i = 0, len = ast.declarations.length; i < len; i++) {
            var d = ast.declarations[i];
            processVariableDeclarator(d);
            if(d.__protectedClass) {
                protectedCnt++;
                if(protectedClasses.indexOf(d.__protectedClass) < 0) {
                    protectedClasses.push(d.__protectedClass);
                    protectedClassLv = d.__protectedClassLv;
                }
            }
        }
        // 以下是为了方便处理将表格结构定义移除
        if(protectedCnt == ast.declarations.length && protectedClasses.length == 1) {
            ast.__protectedClass = protectedClasses[0];
            ast.__protectedClassLv = protectedClassLv + 1;
        }
    }

    function processVariableDeclarator(ast) {
        processIdentifier(ast.id);
        if(ast.init) {
            processAST(ast.init);
            if(ast.init.__protectedClass) {
                // console.log('get laya class for declarator: ' + ast.init.__protectedClass);
                ast.__protectedClass = ast.init.__protectedClass;
                ast.__protectedClassLv = ast.init.__protectedClassLv + 1;
            }
        }
    }

    function processThisExpression(ast) {
        // do nothing...
    }

    function processArrayExpression(ast) {
        for(var i = 0, len = ast.elements.length; i < len; i++) {
            var e = ast.elements[i];
            if(e) {
                processAST(e);
            }
        }
    }

    function processObjectExpression(ast) {
        for(var i = 0, len = ast.properties.length; i < len; i++) {
            processAST(ast.properties[i]);
        }
    }

    function processProperty(ast) {
        processAST(ast.key);
        processAST(ast.value);
    }

    function processFunctionExpression(ast) {
        processFunction(ast);
    }

    function processUnaryExpression(ast) {
        ast.__calPriority = getCalPriority(ast.prefix ? ast.operator + ' …' : '… ' + ast.operator);
        processUnaryOperator(ast.operator);
        processAST(ast.argument);
    }

    function processUnaryOperator(ast) {
        // do nothing...        
    }

    function processUpdateExpression(ast) {
        ast.__calPriority = getCalPriority(ast.prefix ? ast.operator + ' …' : '… ' + ast.operator);
        processUpdateOperator(ast.operator);
        processAST(ast.argument);
    }

    function processUpdateOperator(ast) {
        // do nothing...        
    }

    function processBinaryExpression(ast) {
        ast.__calPriority = getCalPriority('… ' + ast.operator + ' …');
        processBinaryOperator(ast.operator);
        processAST(ast.left);
        processAST(ast.right);
    }

    function processBinaryOperator(ast) {
        // do nothing...        
    }

    function processAssignmentExpression(ast) {
        ast.__calPriority = getCalPriority('… ' + ast.operator + ' …');
        processAssignmentOperator(ast.operator);
        processAST(ast.left);
        processAST(ast.right);
    }

    function processAssignmentOperator(ast) {
        // do nothing...    
    }

    function processLogicalExpression(ast) {
        ast.__calPriority = getCalPriority('… ' + ast.operator + ' …');
        processLogicalOperator(ast.operator);
        processAST(ast.left);
        processAST(ast.right);
    }

    function processLogicalOperator(ast) {
        // do nothing...    
    }

    function processMemberExpression(ast) {
        ast.__calPriority = getCalPriority(ast.computed ? '… [ … ]' : '… . …');        
        processAST(ast.object);
        processAST(ast.property);
        
        // 需在处理完object和property后判断
        if(ast.property.type == 'Identifier') {            
            if(/^_\$[sg]et_/.test(ast.property.name)) {
                // _$get_/_$set_不混淆，否则拿不到对应的属性
                ast.property.__noUgly = true;    
            }
            if(ast.object.type == 'Identifier' && (ast.object.name == 'KW' || ast.object.name == 'Macros')) {
                // KW和Macros的静态变量不混淆，太多了耗
                ast.property.__noUgly = true;      
            }            
            if(ast.object.type == 'Identifier' && stopUglyMap[ast.object.name]) {
                // window相关的也不混淆，window.xxx.yyy.zzz的情况，设置window.xxx.yyy from window
                ast.property.__fromWindow = true;
                ast.__fromWindow = true;
            }
            if(stopUglyMap[ast.property.name]) {
                ast.__fromWindow = true;
            }
            if(ast.object.type == 'MemberExpression' && ast.object.__fromWindow) {
                // window相关的也不混淆，window.xxx.yyy.zzz的情况，设置window.xxx.yyy.zzz和zzz from window
                ast.property.__fromWindow = true;
                ast.__fromWindow = true;
            }
        } 
    }

    function processConditionalExpression(ast) {
        ast.__calPriority = getCalPriority('… ? … : …');
        processAST(ast.test);
        processAST(ast.alternate);
        processAST(ast.consequent);
    }

    function processCallExpression(ast) {
        ast.__calPriority = getCalPriority('… ( … )');
        ast.callee.__functionName = true;
        // 需在process子节点前判断是否laya class
        if(ast.callee.type == 'Identifier' && ast.callee.name == '__class') {
            // _class的第2个参数是包路径，不予混淆
            var packageName = ast.arguments[1].value;
            var pa = packageName.split('.');
            for(var i = 0, len = pa.length; i < len; i++) {
                noUglyMap[pa[i]] = true;
            }
            // laya相关的类均不混淆，配置结构和Plat也不混淆，避免平台接口被混掉
            if(pa[0] == 'laya' || pa[0] == 'PathFinding' || cfgPkgRe.test(packageName) || /subpackage\.system\.game\./.test(packageName)) {
                ast.callee.__protectedClass = packageName;
                ast.callee.__protectedClassLv = 0;
            }
        }        
        processAST(ast.callee);
        for(var i = 0, len = ast.arguments.length; i < len; i++) {
            processAST(ast.arguments[i]);
        }
        if(ast.callee.__protectedClass) {
            // console.log('get laya class for CallExpression: ' + ast.callee.__protectedClass);
            ast.__protectedClass = ast.callee.__protectedClass;
            ast.__protectedClassLv = ast.callee.__protectedClassLv + 1;
        }
    }

    function processNewExpression(ast) {
        // 由于表格结构会被删除，此处要检查是否new一个表格结构
        if(ast.callee.type == 'Identifier' && cfgClassNameMap[ast.callee.name]) {
            throw new Error('try to new a cfg: ' + ast.callee.name);
        }
        if(ast.arguments.length > 0) {
            ast.__calPriority = getCalPriority('new … ( … )');
        } else {
            ast.__calPriority = getCalPriority('new …');
        }
        processAST(ast.callee);
        for(var i = 0, len = ast.arguments.length; i < len; i++) {
            processAST(ast.arguments[i]);
        }
    }

    function processSequenceExpression(ast) {
        ast.__calPriority = getCalPriority('… , …');
        for(var i = 0, len = ast.expressions.length; i < len; i++) {
            processAST(ast.expressions[i]);
        }
    }

    function buildUglyPool() {
        var ltr = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '_', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
        var ltrnum = ltr.concat([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
        for(var i = 0, ltrLen = ltr.length; i < ltrLen; i++) {
            var s = ltr[i];
            for(var j = 0, ltrnumLen = ltrnum.length; j < ltrnumLen; j++) {
                var u = s + ltrnum[j];
                if(!protectedMap[u] && !recordMap[u]) {
                    uglyPool.push(u);
                }
                for(var k = 0, ltrnumLen = ltrnum.length; k < ltrnumLen; k++) {
                    var uk = u + ltrnum[k];
                    if(!protectedMap[uk] && !recordMap[u]) {
                        uglyPool.push(uk);
                    }
                }
            }
        }
    }

    function toUgly(raw) {
        if(noUglyMap[raw] || protectedMap[raw] || raw.length < 2) return raw;
        var u = uglyMap[raw];
        if(!u) {
            var plen = uglyPool.length;
            if(plen > 0) {
                var idx = Math.floor(Math.random() * plen);
                u = uglyPool[idx];
                uglyPool.splice(idx, 1);
            } else {
                console.error('ERROR: ugly pool run out: ' + raw);
                u = raw;
            }
            uglyMap[raw] = u;
        }
        return u;
    }

    // 根据语法树生成代码
    function codeFromAST(ast) {
        if(!ast) {
            return '--null--';
        }
        // 微信子包会有这些引用，先不去除
        // if(cfgPkgRe.test(ast.__protectedClass)){
            // return '';
        // }
        
        var code = '';
        switch(ast.type) {
            case 'Identifier':
                code = codeFromIdentifier(ast);
                break;
            case 'Literal':
                code = codeFromLiteral(ast);
                break;
            case 'RegExpLiteral':
                code = codeFromRegExpLiteral(ast);
                break;
            case 'Program':
                code = codeFromProgram(ast);
                break;
            case 'Function':
                code = codeFromFunction(ast);
                break;
            case 'ExpressionStatement':
                code = codeFromExpressionStatement(ast);
                break;
            case 'Directive':
                code = codeFromDirective(ast);
                break;
            case 'BlockStatement':
                code = codeFromBlockStatement(ast);
                break;
            case 'FunctionBody':
                code = codeFromFunctionBody(ast);
                break;
            case 'EmptyStatement':
                code = codeFromEmptyStatement(ast);
                break;
            case 'DebuggerStatement':
                code = codeFromDebuggerStatement(ast);
                break;
            case 'WithStatement':
                code = codeFromWithStatement(ast);
                break;
            case 'ReturnStatement':
                code = codeFromReturnStatement(ast);
                break;
            case 'LabeledStatement':
                code = codeFromLabeledStatement(ast);
                break;
            case 'BreakStatement':
                code = codeFromBreakStatement(ast);
                break;
            case 'ContinueStatement':
                code = codeFromContinueStatement(ast);
                break;
            case 'IfStatement':
                code = codeFromIfStatement(ast);
                break;
            case 'SwitchStatement':
                code = codeFromSwitchStatement(ast);
                break;
            case 'SwitchCase':
                code = codeFromSwitchCase(ast);
                break;
            case 'ThrowStatement':
                code = codeFromThrowStatement(ast);
                break;
            case 'TryStatement':
                code = codeFromTryStatement(ast);
                break;
            case 'CatchClause':
                code = codeFromCatchClause(ast);
                break;
            case 'WhileStatement':
                code = codeFromWhileStatement(ast);
                break;
            case 'DoWhileStatement':
                code = codeFromDoWhileStatement(ast);
                break;
            case 'ForStatement':
                code = codeFromForStatement(ast);
                break;
            case 'ForInStatement':
                code = codeFromForInStatement(ast);
                break;
            case 'FunctionDeclaration':
                code = codeFromFunctionDecalaration(ast);
                break;
            case 'VariableDeclaration':
                code = codeFromVariableDeclaration(ast);
                break;
            case 'VariableDeclarator':
                code = codeFromVariableDeclarator(ast);
                break;
            case 'ThisExpression':
                code = codeFromThisExpression(ast);
                break;
            case 'ArrayExpression':
                code = codeFromArrayExpression(ast);
                break;
            case 'ObjectExpression':
                code = codeFromObjectExpression(ast);
                break;
            case 'Property':
                code = codeFromProperty(ast);
                break;
            case 'FunctionExpression':
                code = codeFromFunctionExpression(ast);
                break;
            case 'UnaryExpression':
                code = codeFromUnaryExpression(ast);
                break;
            case 'UnaryOperator':
                code = codeFromUnaryOperator(ast);
                break;
            case 'UpdateExpression':
                code = codeFromUpdateExpression(ast);
                break;
            case 'UpdateOperator':
                code = codeFromUpdateOperator(ast);
                break;
            case 'BinaryExpression':
                code = codeFromBinaryExpression(ast);
                break;
            case 'BinaryOperator':
                code = codeFromBinaryOperator(ast);
                break;
            case 'AssignmentExpression':
                code = codeFromAssignmentExpression(ast);
                break;
            case 'AssignmentOperator':
                code = codeFromAssignmentOperator(ast);
                break;
            case 'LogicalExpression':
                code = codeFromLogicalExpression(ast);
                break;
            case 'LogicalOperator':
                code = codeFromLogicalOperator(ast);
                break;
            case 'MemberExpression':
                code = codeFromMemberExpression(ast);
                break;
            case 'ConditionalExpression':
                code = codeFromConditionalExpression(ast);
                break;
            case 'CallExpression':
                code = codeFromCallExpression(ast);
                break;
            case 'NewExpression':
                code = codeFromNewExpression(ast);
                break;
            case 'SequenceExpression':
                code = codeFromSequenceExpression(ast);
                break;
            default:
                console.error('ERROR: unknown syntax type: ' + ast.type);
                break;
        }
        return code;
    }

    function codeFromIdentifier(ast) {
        if(doMakeItUgly && !ast.__noUgly && !ast.__fromWindow) {
            ast.name = toUgly(ast.name);
        }
        return ast.name;
    }

    function codeFromLiteral(ast) {
        if(ast.regex) {
            // 正则
            return codeFromRegExpLiteral(ast)
        }
        return ast.raw;
    }

    function codeFromRegExpLiteral(ast) {
        return '/' + ast.regex.pattern + '/' + ast.regex.flags;
    }

    function codeFromProgram(pgm) {
        var code = '';
        if(pgm.body instanceof Array) {
            for(var i = 0, len = pgm.body.length; i < len; i++) {
                code += codeFromAST(pgm.body[i]);
                if(i < len - 1) {
                    code += formatNewLine;
                }
            }
        } else {
            code += codeFromAST(pgm.body);
        }
        return code;
    }

    function codeFromFunction(ast) {
        var code = 'function';
        if(ast.id) {
            code += ' '+ codeFromAST(ast.id);
        }
        code += '(';
        if(ast.params) {
            for(var i = 0, len = ast.params.length; i < len; i ++) {
                code += codeFromAST(ast.params[i]);
                if(i < len - 1) {
                    code += ','
                }
            }
        }
        code += ')';
        var bodyCode = codeFromAST(ast.body);
        if(ast.body.type != 'BlockStatement') {
            bodyCode = '{' + formatNewLine + bodyCode + formatNewLine + '}';
        }
        code += bodyCode;
        return code + formatNewLine;
    }

    function codeFromExpressionStatement(ast) {
        return codeFromAST(ast.expression) + ';';
    }

    function codeFromDirective(ast) {
        console.error('ERROR: codeFromDirective');
    }

    function codeFromBlockStatement(ast) {
        var code = '{';
        for(var i = 0, len = ast.body.length; i < len; i++) {
            var t = codeFromAST(ast.body[i]);
            code += t;
            code += formatNewLine;
        }
        code += '}';
        return code;
    }

    function codeFromEmptyStatement(ast) {
        return ';';
    }

    function codeFromDebuggerStatement(ast) {
        return 'debugger;';
    }

    function codeFromWithStatement(ast) {
        var code = 'with(' + codeFromAST(ast.object) + ')';
        var bodyCode = codeFromAST(ast.body);
        if(ast.body.type != 'BlockStatement') {
            bodyCode = '{' + formatNewLine + bodyCode + formatNewLine + '}';
        }
        code += bodyCode;
        return code + formatNewLine;
    }

    function codeFromReturnStatement(ast) {
        var code = 'return';
        if(ast.argument) {
            code += ' ' + codeFromAST(ast.argument); 
        }
        return code + ';' + formatNewLine;
    }

    function codeFromLabeledStatement(ast) {
        console.error('ERROR: codeFromLabeledStatement');
        codeFromAST(ast.label);
        codeFromAST(ast.body);
    }

    function codeFromBreakStatement(ast) {
        var code = 'break';
        if(ast.label) {
            code += ' ' + codeFromAST(ast.label);
        }
        return code + ';' + formatNewLine;
    }

    function codeFromContinueStatement(ast) {
        var code = 'continue';
        if(ast.label) {
            code += ' ' + codeFromAST(ast.label);
        }
        return code + ';' + formatNewLine;
    }

    function codeFromIfStatement(ast) {
        var code = 'if(' + codeFromAST(ast.test) + ')' + formatNewLine;
        var consequentCode = codeFromAST(ast.consequent);
        code += formatNewLine + consequentCode + formatNewLine;
        if(ast.alternate) {
            code += 'else' + formatNewLine;
            var alternateCode = codeFromAST(ast.alternate);
            if(ast.alternate.type != 'BlockStatement') {
                alternateCode = ' ' + alternateCode;
                if(ast.alternate.type != 'IfStatement' && alternateCode.charAt(alternateCode.length - 1) != ';') {
                    alternateCode += ';';
                }
            }
            code += alternateCode;
        }
        return code + formatNewLine;
    }

    function codeFromSwitchStatement(ast) {
        var code = 'switch(' + codeFromAST(ast.discriminant) + '){' + formatNewLine;
        for(var i = 0, len = ast.cases.length; i < len; i++) {
            code += codeFromAST(ast.cases[i]);
        }
        return code + '}' + formatNewLine;
    }

    function codeFromSwitchCase(ast) {
        var code = '';
        if(ast.test){
            code += 'case ' + codeFromAST(ast.test) + ':' + formatNewLine;
        } else {
            code += 'default:' + formatNewLine;
        }
        for(var i = 0, len = ast.consequent.length; i < len; i++) {
            code += codeFromAST(ast.consequent[i]);
        }
        return code;
    }

    function codeFromThrowStatement(ast) {
        return 'throw ' + codeFromAST(ast.argument) + ';' + formatNewLine;
    }

    function codeFromTryStatement(ast) {
        var code = 'try' + codeFromAST(ast.block);
        if(ast.handler) {
            code += codeFromAST(ast.handler);
        }
        if(ast.finalizer) {
            code += 'finally' + codeFromAST(ast.finalizer);
        }
        return code;
    }

    function codeFromCatchClause(ast) {
        var code = 'catch(' + codeFromAST(ast.param) + ')';
        code += codeFromAST(ast.body);
        return code;
    }

    function codeFromWhileStatement(ast) {
        var code = 'while(' + codeFromAST(ast.test) + ')' + formatNewLine;
        var bodyCode = codeFromAST(ast.body);
        code += bodyCode;
        return code + formatNewLine;
    }

    function codeFromDoWhileStatement(ast) {
        var code = 'do';
        var bodyCode = codeFromAST(ast.body);
        if(ast.body.type != 'BlockStatement') {
            bodyCode = '{' + bodyCode + '}';
        }
        code += bodyCode;        
        code += 'while(';
        code += codeFromAST(ast.test);
        return code + ')' + formatNewLine;
    }

    function codeFromForStatement(ast) {
        var code = 'for(';
        if(ast.init) {
            code += codeFromAST(ast.init);
            if(code.charAt(code.length - 1) != ';') {
                code += ';';
            }
        } else {
            code += ';';
        }        
        if(ast.test) {
            code += codeFromAST(ast.test);
        }
        code += ';';
        if(ast.update) {
            code += codeFromAST(ast.update);
        }
        code += ')';
        var bodyCode = codeFromAST(ast.body);
        code += bodyCode;
        return code + formatNewLine;
    }

    function codeFromForInStatement(ast) {
        ast.left.noSemicolon = true;
        var code = 'for(' + codeFromAST(ast.left) + ' in ' + codeFromAST(ast.right) + ')';
        var bodyCode = codeFromAST(ast.body);
        code += bodyCode;
        return code + formatNewLine;
    }

    function codeFromFunctionDecalaration(ast) {
        return codeFromFunction(ast) + formatNewLine;
    }

    function codeFromVariableDeclaration(ast) {
        var code = ast.kind + ' ';
        for(var i = 0, len = ast.declarations.length; i < len; i++) {
            code += codeFromVariableDeclarator(ast.declarations[i]);
            if(len > 1 && i < len - 1) {
                code += ','
            }
        }
        if(!ast.noSemicolon) {
            code += ';';
        }
        return code;
    }

    function codeFromVariableDeclarator(ast) {
        var code = codeFromAST(ast.id);
        if(ast.init) {
            code += '=' + codeFromAST(ast.init);
        }
        return code;
    }

    function codeFromThisExpression(ast) {
        return 'this';
    }

    function codeFromArrayExpression(ast) {
        var code = '[';
        if(ast.elements) {
            for(var i = 0, len = ast.elements.length; i < len; i++) {
                if(i > 0) {
                    code += ', ';
                }
                var e = ast.elements[i];
                if(e) {
                    // 比如[1,,3]这种情况
                    code += codeFromAST(e);
                }                   
            }
        }
        return code + ']';
    }

    function codeFromObjectExpression(ast) {
        var code = '{';
        for(var i = 0, len = ast.properties.length; i < len; i++) {
            code += codeFromAST(ast.properties[i]);
            if(len > 1 && i < len - 1) {
                code += ',' + formatNewLine;
            }
        }
        return code + '}';
    }

    function codeFromProperty(ast) {
        return codeFromAST(ast.key) + ':' + codeFromAST(ast.value);
    }

    function codeFromFunctionExpression(ast) {
        var code = codeFromFunction(ast);
        if(ast.__fromCallExpression) {
            // 函数表达式
            code = '(' + code + ')';
        }
        return code;
    }

    function codeFromUnaryExpression(ast) {
        var code;
        var agm = codeFromAST(ast.argument);
        if(ast.argument.__calPriority >= ast.__calPriority) {
            agm = '(' + agm + ')';
        }
        if(ast.prefix) {
            code = codeFromUnaryOperator(ast.operator);
            if('typeof' == ast.operator || 'void' == ast.operator || 'delete' == ast.operator) {
                code += ' ';
            }
            code += agm;
        } else {
            code = agm + codeFromUnaryOperator(ast.operator);
        }
        return code;        
    }

    function codeFromUnaryOperator(ast) {
        return ast;
    }

    function codeFromUpdateExpression(ast) {
        var code = codeFromAST(ast.argument);
        if(ast.argument.__calPriority >= ast.__calPriority) {
            code = '(' + code+ ')';
        }
        if(ast.prefix) {
            code = codeFromUpdateOperator(ast.operator) + code;
        } else {
            code = code + codeFromUpdateOperator(ast.operator);
        }
        return code;
    }

    function codeFromUpdateOperator(ast) {
        return ast;
    }

    function codeFromBinaryExpression(ast) {
        var left = codeFromAST(ast.left);
        if(ast.left.__calPriority >= ast.__calPriority) {
            left = '(' + left + ')';
        } 
        var right = codeFromAST(ast.right);
        if(ast.right.__calPriority >= ast.__calPriority) {
            right = '(' + right + ')';
        }
        var code = left;
        if(left.charAt(left.length - 1) != ' ') {
            code += ' ';
        }
        code += codeFromBinaryOperator(ast.operator);
        if(right.charAt(0) != ' ') {
            code += ' ';
        }
        code += right;
        return code;
    }

    function codeFromBinaryOperator(ast) {
        return ast;   
    }

    function codeFromAssignmentExpression(ast) {
        return codeFromAST(ast.left) + codeFromAssignmentOperator(ast.operator) + codeFromAST(ast.right);
    }

    function codeFromAssignmentOperator(ast) {
        return ast;
    }

    function codeFromLogicalExpression(ast) {
        var left = codeFromAST(ast.left);
        if(ast.left.__calPriority >= ast.__calPriority) {
            left = '(' + left + ')';
        } 
        var right = codeFromAST(ast.right);
        if(ast.right.__calPriority >= ast.__calPriority) {
            right = '(' + right + ')';
        } 
        var code = left + codeFromLogicalOperator(ast.operator) + right;
        return code;
    }

    function codeFromLogicalOperator(ast) {
        return ast;
    }

    function codeFromMemberExpression(ast) {
        var code = codeFromAST(ast.object);
        if(noBraceTypes.indexOf(ast.object.type) < 0) {
            code = '(' + code + ')';
        }
        if(ast.computed) {
            code += '[' + codeFromAST(ast.property) + ']';
        } else {
            code += '.' + codeFromAST(ast.property);
        }
        return code;
    }

    function codeFromConditionalExpression(ast) {
        return '(' +codeFromAST(ast.test) + ')?(' +codeFromAST(ast.consequent) + '):(' + codeFromAST(ast.alternate) + ')';
    }

    function codeFromCallExpression(ast) {
        ast.callee.__fromCallExpression = true;
        var code = codeFromAST(ast.callee);
        if(ast.callee.__calPriority > ast.__calPriority) {
            code = '(' + code + ')';
        }
        code += '(';
        for(var i = 0, len = ast.arguments.length; i < len; i++) {
            code += codeFromAST(ast.arguments[i]);
            if(len > 1 && i < len - 1) {
                code += ',';
            }
        }
        return code + ')';
    }

    function codeFromNewExpression(ast) {
        var calleeCode = codeFromAST(ast.callee);
        if(ast.callee.__calPriority > ast.__calPriority) {
            calleeCode = '(' + calleeCode + ')';
        }
        var code = 'new ' + calleeCode + '(';
        for(var i = 0, len = ast.arguments.length; i < len; i++) {
            code += codeFromAST(ast.arguments[i]);
            if(i < len - 1) {
                code += ',';
            }
        }
        return code + ')';
    }

    function codeFromSequenceExpression(ast) {
        var code = '(';
        for(var i = 0, len = ast.expressions.length; i < len; i++) {
            code += codeFromAST(ast.expressions[i]);
            if(i < len - 1) {
                code += ',';
            }
        }
        return code + ')';
    }

    function getCalPriority(raw) {
        var idx = operatorPriorityMap[raw];
        if(idx < 0) {
            idx = 999;
            console.error('no prioritys: ' + raw);
        }
        return idx;
    }

    // 对比语法树
    function compareAST(ast1, ast2) {
        var error;
        if((ast1 && !ast2) || (!ast1 && ast2)) {
            error = '[compareAST]ast not equal! ast1 = ' + JSON.stringify(ast1) + ', ast2 = ' + JSON.stringify(ast2);
        } else if(ast1) {
            if(ast1.type != ast2.type) {
                error = '[compareAST]ast type not equal!';
            } else {
                switch(ast1.type) {
                    case 'Node':
                        error = compareNode(ast1, ast2);
                        break;
                    case 'Identifier':
                        error = compareIdentifier(ast1, ast2);
                        break;
                    case 'Literal':
                        error = compareLiteral(ast1, ast2);
                        break;
                    case 'RegExpLiteral':
                        error = compareRegExpLiteral(ast1, ast2);
                        break;
                    case 'Program':
                        error = compareProgram(ast1, ast2);
                        break;
                    case 'Function':
                        error = compareFunction(ast1, ast2);
                        break;
                    case 'ExpressionStatement':
                        error = compareExpressionStatement(ast1, ast2);
                        break;
                    case 'Directive':
                        error = compareDirective(ast1, ast2);
                        break;
                    case 'BlockStatement':
                        error = compareBlockStatement(ast1, ast2);
                        break;
                    case 'FunctionBody':
                        error = compareFunctionBody(ast1, ast2);
                        break;
                    case 'EmptyStatement':
                        error = compareEmptyStatement(ast1, ast2);
                        break;
                    case 'DebuggerStatement':
                        error = compareDebuggerStatement(ast1, ast2);
                        break;
                    case 'WithStatement':
                        error = compareWithStatement(ast1, ast2);
                        break;
                    case 'ReturnStatement':
                        error = compareReturnStatement(ast1, ast2);
                        break;
                    case 'LabeledStatement':
                        error = compareLabeledStatement(ast1, ast2);
                        break;
                    case 'BreakStatement':
                        error = compareBreakStatement(ast1, ast2);
                        break;
                    case 'ContinueStatement':
                        error = compareContinueStatement(ast1, ast2);
                        break;
                    case 'IfStatement':
                        error = compareIfStatement(ast1, ast2);
                        break;
                    case 'SwitchStatement':
                        error = compareSwitchStatement(ast1, ast2);
                        break;
                    case 'SwitchCase':
                        error = compareSwitchCase(ast1, ast2);
                        break;
                    case 'ThrowStatement':
                        error = compareThrowStatement(ast1, ast2);
                        break;
                    case 'TryStatement':
                        error = compareTryStatement(ast1, ast2);
                        break;
                    case 'CatchClause':
                        error = compareCatchClause(ast1, ast2);
                        break;
                    case 'WhileStatement':
                        error = compareWhileStatement(ast1, ast2);
                        break;
                    case 'DoWhileStatement':
                        error = compareDoWhileStatement(ast1, ast2);
                        break;
                    case 'ForStatement':
                        error = compareForStatement(ast1, ast2);
                        break;
                    case 'ForInStatement':
                        error = compareForInStatement(ast1, ast2);
                        break;
                    case 'FunctionDeclaration':
                        error = compareFunctionDecalaration(ast1, ast2);
                        break;
                    case 'VariableDeclaration':
                        error = compareVariableDeclaration(ast1, ast2);
                        break;
                    case 'VariableDeclarator':
                        error = compareVariableDeclarator(ast1, ast2);
                        break;
                    case 'ThisExpression':
                        error = compareThisExpression(ast1, ast2);
                        break;
                    case 'ArrayExpression':
                        error = compareArrayExpression(ast1, ast2);
                        break;
                    case 'ObjectExpression':
                        error = compareObjectExpression(ast1, ast2);
                        break;
                    case 'Property':
                        error = compareProperty(ast1, ast2);
                        break;
                    case 'FunctionExpression':
                        error = compareFunctionExpression(ast1, ast2);
                        break;
                    case 'UnaryExpression':
                        error = compareUnaryExpression(ast1, ast2);
                        break;
                    case 'UnaryOperator':
                        error = compareUnaryOperator(ast1, ast2);
                        break;
                    case 'UpdateExpression':
                        error = compareUpdateExpression(ast1, ast2);
                        break;
                    case 'UpdateOperator':
                        error = compareUpdateOperator(ast1, ast2);
                        break;
                    case 'BinaryExpression':
                        error = compareBinaryExpression(ast1, ast2);
                        break;
                    case 'BinaryOperator':
                        error = compareBinaryOperator(ast1, ast2);
                        break;
                    case 'AssignmentExpression':
                        error = compareAssignmentExpression(ast1, ast2);
                        break;
                    case 'AssignmentOperator':
                        error = compareAssignmentOperator(ast1, ast2);
                        break;
                    case 'LogicalExpression':
                        error = compareLogicalExpression(ast1, ast2);
                        break;
                    case 'LogicalOperator':
                        error = compareLogicalOperator(ast1, ast2);
                        break;
                    case 'MemberExpression':
                        error = compareMemberExpression(ast1, ast2);
                        break;
                    case 'ConditionalExpression':
                        error = compareConditionalExpression(ast1, ast2);
                        break;
                    case 'CallExpression':
                        error = compareCallExpression(ast1, ast2);
                        break;
                    case 'NewExpression':
                        error = compareNewExpression(ast1, ast2);
                        break;
                    case 'SequenceExpression':
                        error = compareSequenceExpression(ast1, ast2);
                        break;
                    default:
                        if(ast1 != ast2) {
                            error = '[error = compareAST]ast value not equal!';
                        }
                        break;
                }
            }
        }            
        
        if(error && !errorMsg) {
            console.log('diffs from two ast!');
            var astSimp1 = astToSimpleString(ast1) ;
            var astSimp2 = astToSimpleString(ast2) ;
            errorMsg = error + '\nast1=' + astSimp1 + '\nast2=' + astSimp2;
            astSaved1 = 'code>>\n' + codeFromAST(ast1) + '\n\nast>>\n' + astSimp1;
            astSaved2 = 'code>>\n' + codeFromAST(ast2) + '\n\nast>>\n' + astSimp2;
        }
        
        return error;
    }

    function checkDisplayError() {
        if(errorMsg) {
            //console.error(errorMsg);
            fs.writeFile('ast1.json', astSaved1, function(err) {
                if (err) {
                    throw err;
                }
                console.log('ast1.json saved.');
            });
            fs.writeFile('ast2.json', astSaved2, function(err) {
                if (err) {
                    throw err;
                }
                console.log('ast2.json saved.');
            });
        }
    }

    function compareNode(ast1, ast2) {
        return null;
    }

    function compareIdentifier(ast1, ast2) {
        if(ast1.name != ast2.name) {
            return '[Identifier]name not equal.';
        }
        return null;
    }

    function compareLiteral(ast1, ast2) {
        var isRe1 = ast1.value instanceof RegExp;
        var isRe2 = ast2.value instanceof RegExp;
        if(isRe1 != isRe2) {
            return '[Literal]value type not equal.';
        }
        if(isRe1) {
            if(ast1.value.source != ast2.value.source) {
                return '[Literal]regexp not equal.';
            }
        } else if(ast1.value != ast2.value) {
            return '[Literal]value not equal.';
        }
        return null;
    }

    function compareRegExpLiteral(ast1, ast2) {
        if(ast1.regex.pattern != ast2.regex.pattern) {
            return '[RegExpLiteral]regex pattern not equal.';
        }
        if(ast1.regex.flags != ast2.regex.flags) {
            return '[RegExpLiteral]regex flags not equal.';
        }
        return compareLiteral(ast1, ast2);
    }

    function compareProgram(pgm1, pgm2) {
        var len1 = pgm1.body.length;
        var len2 = pgm2.body.length;
        if(len1 != len2)  {
            return '[Program]body length not equal.';
        }
        for(var i = 0; i < len1; i++) {
            var rst = compareAST(pgm1.body[i], pgm2.body[i]);
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareFunction(ast1, ast2) {
        if((ast1.id && !ast2.id) || (!ast1.id && ast2.id)) {
            return '[Function]function id not equal.';
        }
        if(ast1.id) {
            var rst = compareAST(ast1.id, ast2.id);
            if(rst) {
                return rst;
            }
        }
        var len1 = ast1.params.length;
        var len2 = ast2.params.length;
        if(len1 != len2)  {
            return '[Function]params length not equal.';
        }
        for(var i = 0; i < len1; i ++) {
            var rst = compareAST(ast1.params[i], ast2.params[i]);
            if(rst) {
                return rst;
            }
        }
        return compareAST(ast1.body, ast2.body);
    }

    function compareExpressionStatement(ast1, ast2) {
        return compareAST(ast1.expression, ast2.expression);
    }

    function compareDirective(ast1, ast2) {
        console.error('ERROR: compareDirective');
        return compareLiteral(ast1.expression, ast2.expression);
    }

    function compareBlockStatement(ast1, ast2) {
        var len1 = ast1.body.length;
        var len2 = ast2.body.length;
        if(len1 != len2)  {
            return '[BlockStatement]body length not equal.';
        }
        for(var i = 0; i < len1; i++) {
            var rst = compareAST(ast1.body[i], ast2.body[i]);
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareFunctionBody(ast1, ast2) {
        return compareAST(ast1, ast2);
    }

    function compareEmptyStatement(ast1, ast2) {
        return null;
    }

    function compareDebuggerStatement(ast1, ast2) {
        return null;
    }

    function compareWithStatement(ast1, ast2) {
        return compareAST(ast1.object, ast2.object) || compareAST(ast1.body, ast2.body);
    }

    function compareReturnStatement(ast1, ast2) {
        if((ast1.argument && !ast2.argument) || (!ast1.argument && ast2.argument)) {
            return '[ReturnStatement]argument not equal.';
        }
        if(ast1.argument) {
            var rst = compareAST(ast1.argument, ast2.argument); 
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareLabeledStatement(ast1, ast2) {
        return compareAST(ast1.label, ast2.label) || compareAST(ast1.body, ast2.body);
    }

    function compareBreakStatement(ast1, ast2) {
        if((ast1.label && !ast2.label) || (!ast1.label && ast2.label)) {
            return '[BreakStatement]label not equal.';
        }
        if(ast1.label) {
            var rst = compareAST(ast1.label, ast2.label); 
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareContinueStatement(ast1, ast2) {
        if((ast1.label && !ast2.label) || (!ast1.label && ast2.label)) {
            return '[BreakStatement]label not equal.';
        }
        if(ast1.label) {
            var rst = compareAST(ast1.label, ast2.label); 
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareIfStatement(ast1, ast2) {
        var rst = compareAST(ast1.test, ast2.test) || compareAST(ast1.consequent, ast2.consequent);
        if(rst) {
            return rst;
        }
        if((ast1.alternate && !ast2.alternate) || (!ast1.alternate && ast2.alternate)) {
            return '[IfStatement]alternate not equal.';
        }
        if(ast1.alternate) {
            var rst = compareAST(ast1.alternate, ast2.alternate); 
            if(rst) {
                return rst;
            }
        }
    }

    function compareSwitchStatement(ast1, ast2) {
        var rst = compareAST(ast1.discriminant, ast2.discriminant);
        if(rst) {
            return rst;
        }
        var len1 = ast1.cases.length;
        var len2 = ast2.cases.length;
        if(len1 != len2)  {
            return '[SwitchStatement]cases length not equal.';
        }
        for(var i = 0; i < len1; i++) {
            var rst = compareSwitchCase(ast1.cases[i], ast2.cases[i]);
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareSwitchCase(ast1, ast2) {
        if((ast1.test && !ast2.test) || (!ast1.test && ast2.test)) {
            return '[SwitchCase]test not equal.';
        }
        if(ast1.test) {
            var rst = compareAST(ast1.test, ast2.test); 
            if(rst) {
                return rst;
            }
        }
        var len1 = ast1.consequent.length;
        var len2 = ast2.consequent.length;
        if(len1 != len2)  {
            return '[SwitchCase]consequent length not equal.';
        }
        for(var i = 0; i < len1; i++) {
            var rst = compareAST(ast1.consequent[i], ast2.consequent[i]);
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareThrowStatement(ast1, ast2) {
        return compareAST(ast1.argument, ast2.argument);
    }

    function compareTryStatement(ast1, ast2) {
        var rst = compareBlockStatement(ast1.block, ast2.block);
        if(rst) {
            return rst;
        }
        if((ast1.handler && !ast2.handler) || (!ast1.handler && ast2.handler)) {
            return '[TryStatement]handler not equal.';
        }
        if(ast1.handler) {
            var rst = compareAST(ast1.handler, ast2.handler); 
            if(rst) {
                return rst;
            }
        }
        if((ast1.finalizer && !ast2.finalizer) || (!ast1.finalizer && ast2.finalizer)) {
            return '[TryStatement]finalizer not equal.';
        }
        if(ast1.finalizer) {
            var rst = compareAST(ast1.finalizer, ast2.finalizer); 
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareCatchClause(ast1, ast2) {
        return compareAST(ast1.param, ast2.param) || compareBlockStatement(ast1.body, ast2.body);
    }

    function compareWhileStatement(ast1, ast2) {
        return compareAST(ast1.test, ast2.test) || compareAST(ast1.body, ast2.body);
    }

    function compareDoWhileStatement(ast1, ast2) {
        return compareAST(ast1.body, ast2.body) || compareAST(ast1.test, ast2.test);
    }

    function compareForStatement(ast1, ast2) {
        if((ast1.init && !ast2.init) || (!ast1.init && ast2.init)) {
            return '[ForStatement]init not equal.';
        }
        if(ast1.init) {
            var rst = compareAST(ast1.init, ast2.init); 
            if(rst) {
                return rst;
            }
        }
        if((ast1.test && !ast2.test) || (!ast1.test && ast2.test)) {
            return '[ForStatement]test not equal.';
        }
        if(ast1.test) {
            var rst = compareAST(ast1.test, ast2.test); 
            if(rst) {
                return rst;
            }
        }
        if((ast1.update && !ast2.update) || (!ast1.update && ast2.update)) {
            return '[ForStatement]update not equal.';
        }
        if(ast1.update) {
            var rst = compareAST(ast1.update, ast2.update); 
            if(rst) {
                return rst;
            }
        }
        return compareAST(ast1.body, ast2.body);
    }

    function compareForInStatement(ast1, ast2) {
        return compareAST(ast1.left, ast2.left) || compareAST(ast1.right, ast2.right) || compareAST(ast1.body, ast2.body);
    }

    function compareFunctionDecalaration(ast1, ast2) {
        return compareFunction(ast1, ast2);
    }

    function compareVariableDeclaration(ast1, ast2) {
        var len1 = ast1.declarations.length;
        var len2 = ast2.declarations.length;
        if(len1 != len2)  {
            return '[VariableDeclaration]declarations length not equal.';
        }
        for(var i = 0; i < len1; i++) {
            var rst = compareAST(ast1.declarations[i], ast2.declarations[i]);
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareVariableDeclarator(ast1, ast2) {
        var rst = compareAST(ast1.id, ast2.id);
        if(rst) {
            return rst;
        }
        if((ast1.init && !ast2.init) || (!ast1.init && ast2.init)) {
            return '[VariableDeclarator]init not equal.';
        }
        if(ast1.init) {
            var rst = compareAST(ast1.init, ast2.init); 
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareThisExpression(ast1, ast2) {
        return null;
    }

    function compareArrayExpression(ast1, ast2) {
        var len1 = ast1.elements.length;
        var len2 = ast2.elements.length;
        if(len1 != len2)  {
            return '[ArrayExpression]elements length not equal.';
        }
        for(var i = 0; i < len1; i++) {
            var rst = compareAST(ast1.elements[i], ast2.elements[i]);
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareObjectExpression(ast1, ast2) {
        var len1 = ast1.properties.length;
        var len2 = ast2.properties.length;
        if(len1 != len2)  {
            return '[ObjectExpression]properties length not equal.';
        }
        for(var i = 0; i < len1; i++) {
            var rst = compareAST(ast1.properties[i], ast2.properties[i]);
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareProperty(ast1, ast2) {
        return compareAST(ast1.key, ast2.key) || compareAST(ast1.value, ast2.value);
    }

    function compareFunctionExpression(ast1, ast2) {
        return compareFunction(ast1, ast2);       
    }

    function compareUnaryExpression(ast1, ast2) {
        return compareUnaryOperator(ast1.operator, ast2.operator) || compareAST(ast1.prefix, ast2.prefix) || compareAST(ast1.argument, ast2.argument);
    }

    function compareUnaryOperator(ast1, ast2) {
        if(ast1 != ast2) {
            return '[UnaryOperator]UnaryOperator not equal.';
        }
        return null;
    }

    function compareUpdateExpression(ast1, ast2) {
        return compareUpdateOperator(ast1.operator, ast2.operator) || compareAST(ast1.argument, ast2.argument) || compareAST(ast1.prefix, ast2.prefix);
    }

    function compareUpdateOperator(ast1, ast2) {
        if(ast1 != ast2) {
            return '[UpdateOperator]UpdateOperator not equal.';
        }
        return null;
    }

    function compareBinaryExpression(ast1, ast2) {
        return compareBinaryOperator(ast1.operator, ast2.operator) || compareAST(ast1.left, ast2.left) || compareAST(ast1.right, ast2.right);
    }

    function compareBinaryOperator(ast1, ast2) {
        if(ast1 != ast2) {
            return '[BinaryOperator]BinaryOperator not equal.';
        }
        return null;
    }

    function compareAssignmentExpression(ast1, ast2) {
        return compareAssignmentOperator(ast1.operator, ast2.operator) || compareAST(ast1.left, ast2.left) || compareAST(ast1.right, ast2.right);
    }

    function compareAssignmentOperator(ast1, ast2) {
        if(ast1 != ast2) {
            return '[AssignmentOperator]AssignmentOperator not equal.';
        }
        return null;
    }

    function compareLogicalExpression(ast1, ast2) {
        return compareLogicalOperator(ast1.operator, ast2.operator) || compareAST(ast1.left, ast2.left) || compareAST(ast1.right, ast2.right);
    }

    function compareLogicalOperator(ast1, ast2) {
        if(ast1 != ast2) {
            return '[LogicalOperator]LogicalOperator not equal.';
        }
        return null;
    }

    function compareMemberExpression(ast1, ast2) {
        return compareAST(ast1.object, ast2.object) || compareAST(ast1.property, ast2.property) || compareAST(ast1.computed, ast2.computed);
    }

    function compareConditionalExpression(ast1, ast2) {
        return compareAST(ast1.test, ast2.test) || compareAST(ast1.alternate, ast2.alternate) || compareAST(ast1.consequent, ast2.consequent);
    }

    function compareCallExpression(ast1, ast2) {
        var rst = compareAST(ast1.callee, ast2.callee);
        if(rst) {
            return rst;
        }
        var len1 = ast1.arguments.length;
        var len2 = ast2.arguments.length;
        if(len1 != len2)  {
            return '[CallExpression]arguments length not equal.';
        }
        for(var i = 0; i < len1; i++) {
            var rst = compareAST(ast1.arguments[i], ast2.arguments[i]);
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareNewExpression(ast1, ast2) {
        var rst = compareAST(ast1.callee, ast2.callee);
        if(rst) {
            return rst;
        }
        var len1 = ast1.arguments.length;
        var len2 = ast2.arguments.length;
        if(len1 != len2)  {
            return '[NewExpression]arguments length not equal.';
        }
        for(var i = 0; i < len1; i++) {
            var rst = compareAST(ast1.arguments[i], ast2.arguments[i]);
            if(rst) {
                return rst;
            }
        }
        return null;
    }

    function compareSequenceExpression(ast1, ast2) {
        var len1 = ast1.expressions.length;
        var len2 = ast2.expressions.length;
        if(len1 != len2)  {
            return '[SequenceExpression]expressions length not equal.';
        }
        for(var i = 0; i < len1; i++) {
            var rst = compareAST(ast1.expressions[i], ast2.expressions[i]);
            if(rst) {
                return rst;
            }
        }
        return null;
    }
}