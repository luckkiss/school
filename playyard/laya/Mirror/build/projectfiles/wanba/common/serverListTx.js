// 这种方式不会污染全局空间，可以显示使用window对全局变量赋值
(function (mcParams, httpService) {
    if ((typeof mcParams !== 'object') || (typeof httpService !== 'object')) {
        alert('程序初始化失败，初始化参数错误');
        return null;
    }

    // 注册全局异常处理
    window.onerror = function (msg, url, line, col, error) {
        setTimeout(function () {
            try {
                //不一定所有浏览器都支持col参数，如果不支持就用window.event来兼容
                col = col || (window.event && window.event.errorCharacter) || 0;
                var defaults = {
                    "url": url,
                    "line": line,
                    "col": col,
                    "msg": msg
                };

                if (error && error.stack) {
                    //如果浏览器有堆栈信息，直接使用
                    defaults.msg += error.stack.toString();
                } else if (arguments.callee) {
                    //尝试通过callee拿堆栈信息
                    var ext = [];
                    var fn = arguments.callee.caller;
                    var floor = 3;  //这里只拿三层堆栈信息
                    while (fn && (--floor > 0)) {
                        ext.push(fn.toString());
                        if (fn === fn.caller) {
                            break; //如果有环
                        }
                        fn = fn.caller;
                    }
                    defaults.msg += ext.join(",");
                }
                httpService.reportServerErrorLog(mcParams.logParams.type_js_err, JSON.stringify(defaults));
                console.log('page err: ' + defaults);
            } catch (e) {
                console.log(e);
            }

            return true;
        }, 100); // 避免导致页面挂起
    };

    // 使用 self定义的可以直接被外部调用 使用$scope定义的不能直接被外部调用属于私有属性
    var Application = function (appName, params, httpService) {
        var self = this;
        self.params = params; // 外部可以访问的容器
        self.httpService = httpService;
        var $scope = {}; // 内部私有作用域 便于管理
        $scope.loading = false;
        $scope.serverList = [];
        $scope.selectedList = null;
        $scope.selectedServer = null; // 选择的或则推荐的区服
        $scope.appName = appName;
        $scope.percent = 0;
        $scope.totalJsCnt = 0;
        $scope.totalJsSize = 0;
        $scope.crtProgress = 0;
        $scope.realProgress = 0;  // 真实的加载进度（指js的加载进度）
        $scope.lastChangePrgressAt = 0
        $scope.progressDescIdx = 0;
        $scope.loadDescArr = ['正在加载游戏主文件：({0}%)', '正在加载地图：({0}%)', '正在加载模型：({0}%)', '正在加载UI：({0}%)', '正在加载战斗模块：({0}%)'];
        $scope.unzipDescArr = ['正在解压游戏主文件：({0}%)', '正在解压地图：({0}%)', '正在解压模型：({0}%)', '正在解压UI：({0}%)', '正在解压战斗模块：({0}%'];
        $scope.tipIdx = 0;
        $scope.tipArr = ['正在前往仙侠世界', '每日分享送元宝', '分享游戏赠送极品法器', '首充1元享无限传送 日环1.5倍', '10分钟激活神装装备，卓越武器祝您修仙', '世界BOSS掉落大量装备进阶石'];
        $scope.lastChangeTipAt = 0;
        $scope.loadedMap = {};
        $scope.arrJsContent = [];
        $scope.loadedJsCnt = 0;
        $scope.state = {
            1: 'hot',
            2: 'crowded',
            4: 'maintain'
        };
        $scope.isNew = {
            1: 'isnew'
        };
        $scope.isActiveList = {
            1: 'active'
        };
        $scope.onBootstrapFinish = $scope.onBootstrapBegin = null;

        self.getMTime = function () {
            return self.httpService.getMTime();
        };

        // map 的 polyfill
        self.map = function (arr, func, thisTag) {
            if (Array.prototype.map) {
                return arr.map(func, thisTag);
            } else {
                var mapData = [];
                for (var prop in arr) {
                    mapData[prop] = func.call(thisTag, arr[prop], prop, arr)
                }
                return mapData;
            }
        };

        self.isCallAble = function (callback) {
            return typeof callback === 'function';
        };

        self.callUserFunc = function (func, params, thisArg) {
            try {
                return self.isCallAble(func) && func.apply(thisArg, params);
            } catch (e) {
                console.log('调用用户自定义函数报错：', e);
            }
        };

        // 获取DOM元素
        self.$ = function (elem) {
            elem = (typeof elem === 'string') ? window.document.getElementById(elem) : elem;
            if (!elem) console.log('元素不存在');
            return elem;
        };

        self.toggle = function (elem, state) {
            if (elem = self.$(elem)) {
                state = (state === undefined) ? (elem.style.display === 'none') : state;
                elem.style.display = state ? 'block' : 'none';
            }
            // 用于连贯操作
            return self;
        };

        self.removeProgress = function () {
            // $scope.percent = -1;
            clearInterval($scope.intervalId);
            document.body.removeChild(self.$('barDiv'));
        };

        self.showProgress = function () {
            var now = (new Date()).getTime();
            var progress = $scope.crtProgress;
            if($scope.progressDescIdx == 0 && $scope.realProgress > $scope.crtProgress) {
                progress = $scope.realProgress;
            } else {
                var fakeDelta = $scope.loadSpeed > 0 ? $scope.loadSpeed * (now - $scope.lastChangePrgressAt) : Math.random() * 0.05;
                progress += fakeDelta;
            }
            if($scope.crtProgress != progress) {
                var descArr = $scope.realProgress >= 1 ? $scope.unzipDescArr : $scope.loadDescArr;
                if(progress >= 1) {
                    progress = 0;
                    if($scope.progressDescIdx < descArr.length - 1) {
                        $scope.progressDescIdx++;
                    }
                }
                var progressInPercent = Math.floor(progress * 100);
                var msg = descArr[$scope.progressDescIdx].replace('{0}', progressInPercent);
                self.$('bar').value = progressInPercent;
                self.$('barTxt').innerHTML = msg;
                $scope.crtProgress = progress;
                $scope.lastChangePrgressAt = now;
            }
            if(now - $scope.lastChangeTipAt >= 2000) {
                self.$('tipTxt').innerHTML = $scope.tipArr[$scope.tipIdx];
                $scope.tipIdx++;
                if($scope.tipIdx >= $scope.tipArr.length) {
                    $scope.tipIdx = 0;
                }
                $scope.lastChangeTipAt = now;
            }
        };

        self.setContent = function (elem, content) {
            (elem = self.$(elem)) && (content !== undefined) && (elem.innerHTML = content);
            return self;
        };

        self.showModalMsg = function (elem, msg, contentId) {
            if (elem = self.$(elem)) {
                contentId = contentId || (elem.id + '-msg');
                self.toggle(elem, true).setContent(contentId, msg);
            }
            return self;
        };

        // 这里的 this 会指向 self.service。前提是 必须 app.service.log 进行调用, 不能把 self.service 赋值给其他变量
        self.service = {
            "getAnnouncement": function (fuc) {
                httpService.get({
                    "url": params.announcementUtl + '?v=' + self.getMTime(),
                    "onSuccess": function (response) {
                        fuc(JSON.parse(response.replace(/'/g, '"')))
                    }
                });
            }
        };

        // 切换了区服列表
        self.changeServerList = function (list) {
            var zoneList = document.getElementsByClassName('server-list-btn');
            var i;

            for (i = 0; i < zoneList.length; ++i) {
                if (list == i) {
                    zoneList[i].className = 'server-list-btn active';
                } else {
                    zoneList[i].className = 'server-list-btn';
                }
            }
            (typeof list !== 'object') && (list = $scope.serverList[list]);
            $scope.selectedList = list;
            $scope.buildServerList();
            return self;
        };
        // 选择了区服
        self.changeServer = function (server) {
            (typeof server !== 'object') && (server = $scope.selectedList['list'][server]);
            $scope.selectedServer = server;
            params.selectedServer = server;
            self.toggle('change-server-modal', false);
            var className = 'selected-server selected-server-name ' + $scope.state[$scope.selectedServer.state];
            var selectServer = '<div class="' + className + '">' + $scope.selectedServer.name + '</div><div class="selected-server selected-server-change">点击选服</div>';
            // 设置选择的区服
            self.setContent('selected-server-container', selectServer);
        };

        self.clickStartGame = function () {
            self.httpService.reportStepLog(params.startGameStep, $scope.selectedServer.id);
            $scope.startGame();
        };

        $scope.initServerList = function () {
            $scope.serverList = params.serverList;
            //将最近登录服务器加到选服页列表
            if (params.recentLoginServerList.length > 0) {
                $scope.serverList = [{"name": "最近登录", 'list': params.recentLoginServerList}].concat($scope.serverList);
            }

            if ($scope.serverList.length) {
                // 切换到默认区服列表    选择默认区服
                $scope.buildZoneList();
                if(params.recentLoginServerList.length > 0) {
                    console.log('recent: ' + JSON.stringify(params.recentLoginServerList));
                    self.changeServerList(0).changeServer(0);
                } else if(params.suggestSvr){
                    console.log('suggest: ' + JSON.stringify(params.suggestSvr));
                    self.changeServerList(params.suggestSvr.groupIndex).changeServer(params.suggestSvr.pageIndex);
                } else if(params.suggestSvr2){
                    console.log('suggest 2: ' + JSON.stringify(params.suggestSvr2));
                    self.changeServerList(params.suggestSvr2.groupIndex).changeServer(params.suggestSvr2.pageIndex);
                } else {
                    console.log('no suggest.');
                    self.changeServerList(0).changeServer(0);
                }
            } else {
                self.showModalMsg('msg-modal', '获取区服列表失败');
            }
        };

        $scope.buildZoneList = function () {
            var left = self.map($scope.serverList, function (list, index) {
                var className = 'server-list-btn';
                return '<div class="' + className + '" onclick="' + $scope.appName + '.changeServerList(' + index + ')">' + list.name + '</div>';
            }).join('');
            self.setContent('change-server-body-left', left);
        }
        $scope.buildServerList = function () {
            var right = self.map($scope.selectedList.list, function (server, index) {
                var newServerClass = $scope.isNew[Number(server.isNew)] || '';
                var stateServerClass = $scope.state[server.state] || '';
                return '<div class="server-item"   ng-repeat="server in selectedList.list" onclick="' + $scope.appName + '.changeServer(' + index + ')">' +
                    '<div class="server-item-content ">' +
                    '<div class="server-name ' + stateServerClass + '">' + server.name + '</div></div></div>\n'
            }).join('');

            self.setContent('change-server-body-content', right);
        };

        $scope.showAnnouncement = function () {
            self.service.getAnnouncement(function (announcementJson) {
                var annHtml = '<p>' + '发布时间：' + (announcementJson.m_szDate || '') + '</p>';
                annHtml += '<p>' + (announcementJson.m_szContent || '') + '</p>';
                self.setContent('announcement-modal-msg', annHtml);
                // 直接显示公告
                var ctrlTime = self.httpService.getTimeByTimeStr(announcementJson.m_szCtrlDate);
                var lastSawAnn = parseInt(self.httpService.getCookie('lastSawAnn'));
                if (lastSawAnn < ctrlTime ) {
                    self.toggle('announcement-modal', true);
                    self.httpService.setCookie('lastSawAnn', self.getMTime());
                }
            });
            return self;
        };

        $scope.startGame = function () {
            // 避免疯狂点击
            if ($scope.loading) {
                return false;
            }
            $scope.loading = true;
            if (!$scope.selectedServer || !$scope.selectedServer.id) {
                self.showModalMsg('msg-modal', '请选择一台服务器');
                $scope.loading = false;
                return false;
            }

            $scope.uin = parseInt(self.$('uinInput').value);
            if((window.gameConfig || !window.OPEN_DATA) && !($scope.uin > 0)) {
                //内网测试需输入uin
                self.showModalMsg('msg-modal', '请输入你最心爱的账号');
                $scope.loading = false;
                return false;
            }
            $scope.svrId = parseInt(self.$('svrIdInput').value);
            window.GAME_VARS.server = $scope.selectedServer;
            window.GAME_VARS.uin = $scope.uin;
            window.GAME_VARS.svrId = $scope.svrId;
            window.GAME_VARS.testPlat = self.$('platInput').value;
            self.httpService.setCookie('recentUin', $scope.uin);
            // 保存最近登录列表
            var recentSvrArr = params.recentSvrArr || params.recentSvrsCookie;
            if(!recentSvrArr) {
                recentSvrArr = [];
            }
            var oldIdx = -1;
            for(var i = 0, len = recentSvrArr.length; i < len; i++) {
                var s = recentSvrArr[i];
                if(s.id == $scope.selectedServer.id && (!s.ip || s.ip == $scope.selectedServer.serverIp)) {
                    oldIdx = i;
                    break;
                }
            }
            if(oldIdx > 0) {
                recentSvrArr.splice(oldIdx, 1);
            }
            if(oldIdx != 0) {
                recentSvrArr.unshift({id: $scope.selectedServer.id, ip: $scope.selectedServer.serverIp});
            }
            var svrCookieStr = JSON.stringify(recentSvrArr);
            self.httpService.setCookie('recentSvr' + $scope.uin, svrCookieStr);
            //外网没有uin输入框
            self.httpService.setCookie('recentSvrWeb', svrCookieStr);
            $scope.intoGame();
        };

        $scope.intoGame = function () {
            var container = self.$('container');
            container && document.body.removeChild(container);
            //记录最近登录服务器
            var now = (new Date()).getTime();
            $scope.lastChangePrgressAt = now;
            self.showProgress(); //初始设置3%
            $scope.intervalId = setInterval(function() {
                self.showProgress();
            }, 20);
            $scope.gamevars = {};
            $scope.gamevars.ip = $scope.selectedServer.serverIp;
            $scope.gamevars.clientTime = self.httpService.getClientTime();
            //开始加载Js
            $scope.startLoadJsAt = now;
            $scope.loadAllJs();
            var barDiv = self.$('barDiv');
            barDiv && (barDiv.style.display = 'flex');
        };

        $scope.loadAllJs = function () {
            $scope.totalJsCnt = params.allPreLoadJs.length;
            for (var i = 0; i < $scope.totalJsCnt; i++) {
                var oneJs = params.allPreLoadJs[i];
                $scope.totalJsSize += oneJs.size;
                $scope.loadedMap[oneJs.size] = 0;
                $scope.loadJs(oneJs.url);
            }
        }

        $scope.loadJs = function (jsUrl) {
            httpService.get({
                "url": jsUrl,
                "onSuccess": function (response) {
                    $scope.loadedJsCnt++;
                    self.httpService.reportStepLog(params.preloadStep + $scope.loadedJsCnt, this.url);
                    $scope.arrJsContent.push(response);
                    if($scope.loadedJsCnt >= $scope.totalJsCnt) {
                        self.toggle('msg-modal-container', false);
                        for(var i = 0; i < $scope.totalJsCnt; i++ ) {
                            httpService.addScript($scope.arrJsContent[i]);
                        }
                        $scope.arrJsContent.length = 0;
                        $scope.realProgress = 1;
                        self.showProgress();
                        //Js加载完成
                        self.httpService.reportStepLog(params.addScriptStep);
                        console.log('All js loaded.');
                        // self.removeProgress();
                    }
                },
                "onError": function (err) {
                    httpService.reportServerErrorLog(mcParams.logParams.type_http_err, 'file=js;url:' + this.url + ';err:' + JSON.stringify(err));
                },
                "onProgress": function (event) {
                    if ($scope.totalJsSize > 0) {
                        $scope.loadedMap[this.url] = event.loaded;
                        var totalLoaded = 0;
                        for(var urlKey in $scope.loadedMap) {
                            totalLoaded += $scope.loadedMap[urlKey]
                        }
                        var progress = totalLoaded / $scope.totalJsSize;
                        var now = (new Date()).getTime();
                        $scope.loadSpeed = progress / (now - $scope.startLoadJsAt);
                        $scope.realProgress = progress;
                        self.showProgress();
                    }
                }
            });
        };

        self.onBootstrapBegin = function (callback) {
            $scope.onBootstrapBegin = callback;
            return self;
        };

        self.onBootstrapFinish = function (callback) {
            $scope.onBootstrapFinish = callback;
            return self;
        };
        // 应用启动入口
        self.bootstrap = function () {
            // 开始启动应用
            self.callUserFunc($scope.onBootstrapBegin, [self]);
            self.httpService.reportStepLog(mcParams.loadPageStep);
            // 获取公告 初始化选服页
            $scope.showAnnouncement();
            self.tryInitServerList();
            // 应用启动完毕
            self.callUserFunc($scope.onBootstrapFinish, [self]);
            return self;
        };

        self.tryInitServerList = function () {
            if (mcParams.serverList) {
                $scope.initServerList();
            }
        }
    };

    // 选服页启动 注入依赖; var 声明的变量无法使用delete关键字删除
    window.mcApp = (new Application('window.mcApp', mcParams, httpService)).bootstrap();

    window.onLayaReady = function() {
        console.log('laya is ready.');
        window.mcApp.removeProgress();
    }
    window.onBeforeLoginPHP = function() {
        console.log('on before login php.');
        window.mcApp.httpService.reportStepLog(mcParams.beforeLoginPHPStep);
    }
    window.onAfterLoginPHP = function() {
        console.log('on after login php.');
        window.mcApp.httpService.reportStepLog(mcParams.afterLoginPHPStep);
    }
    window.onGetUINErr = function() {
        console.log('on get uin error: ');
        window.mcApp.httpService.reportStepLog(mcParams.getUINErrStep);
    }
    window.onListRole = function(cnt) {
        console.log('on list role: ' + cnt);
        window.mcApp.httpService.reportStepLog(mcParams.listRoleStep, cnt);
    }
    window.onPrepareCreateRole = function() {
        console.log('on prepare create role.');
        window.mcApp.httpService.reportStepLog(mcParams.prepareCreateRoleStep);
    }
    window.onAfterCreateRole = function() {
        console.log('on after create role.');
        window.mcApp.httpService.reportStepLog(mcParams.afterCreateRoleStep);
    }
    window.onEnterScene = function() {
        console.log('on enter scene.');
        window.mcApp.httpService.reportStepLog(mcParams.enterSceneStep);
    }
    window.recordPaying = function(value) {
        console.log('set paying: ' + value);
        if(value > 0) {
            window.mcApp.httpService.setCookie('paying', window.mcApp.httpService.getMTime());
        } else {
            window.mcApp.httpService.setCookie('paying', '', -1);
        }
    }

})(window.mcParams, window.httpService); // 注入文件以外的依赖 使用window来传递，避免直接挂掉
