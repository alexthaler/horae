var angularLocalStorage=angular.module("LocalStorageModule",[]);angularLocalStorage.constant("prefix","horae");angularLocalStorage.constant("cookie",{expiry:30,path:"/"});angularLocalStorage.service("localStorageService",["$rootScope","prefix","cookie",function($rootScope,prefix,cookie){if(prefix.substr(-1)!=="."){prefix=!!prefix?prefix+".":""}var browserSupportsLocalStorage=function(){try{return"localStorage"in window&&window["localStorage"]!==null}catch(e){$rootScope.$broadcast("LocalStorageModule.notification.error",e.message);return false}};var addToLocalStorage=function(e,t){if(!browserSupportsLocalStorage()){$rootScope.$broadcast("LocalStorageModule.notification.warning","LOCAL_STORAGE_NOT_SUPPORTED");return addToCookies(e,t)}if(!t&&t!==0&&t!=="")return false;try{localStorage.setItem(prefix+e,t)}catch(n){$rootScope.$broadcast("LocalStorageModule.notification.error",n.message);return addToCookies(e,t)}return true};var getFromLocalStorage=function(e){if(!browserSupportsLocalStorage()){$rootScope.$broadcast("LocalStorageModule.notification.warning","LOCAL_STORAGE_NOT_SUPPORTED");return getFromCookies(e)}var t=localStorage.getItem(prefix+e);if(!t)return null;return t};var removeFromLocalStorage=function(e){if(!browserSupportsLocalStorage()){$rootScope.$broadcast("LocalStorageModule.notification.warning","LOCAL_STORAGE_NOT_SUPPORTED");return removeFromCookies(e)}try{localStorage.removeItem(prefix+e)}catch(t){$rootScope.$broadcast("LocalStorageModule.notification.error",t.message);return removeFromCookies(e)}return true};var clearAllFromLocalStorage=function(){if(!browserSupportsLocalStorage()){$rootScope.$broadcast("LocalStorageModule.notification.warning","LOCAL_STORAGE_NOT_SUPPORTED");return clearAllFromCookies()}var e=prefix.length;for(var t in localStorage){if(t.substr(0,e)===prefix){try{removeFromLocalStorage(t.substr(e))}catch(n){$rootScope.$broadcast("LocalStorageModule.notification.error",n.message);return clearAllFromCookies()}}}return true};var browserSupportsCookies=function(){try{return navigator.cookieEnabled||"cookie"in document&&(document.cookie.length>0||(document.cookie="test").indexOf.call(document.cookie,"test")>-1)}catch(e){$rootScope.$broadcast("LocalStorageModule.notification.error",e.message);return false}};var addToCookies=function(e,t){if(typeof t=="undefined")return false;if(!browserSupportsCookies()){$rootScope.$broadcast("LocalStorageModule.notification.error","COOKIES_NOT_SUPPORTED");return false}try{var n="",r=new Date;if(t===null){cookie.expiry=-1;t=""}if(cookie.expiry!==0){r.setTime(r.getTime()+cookie.expiry*24*60*60*1e3);n=", expires="+r.toGMTString()}if(!!e){document.cookie=prefix+e+"="+encodeURIComponent(t)+n+", path="+cookie.path}}catch(i){$rootScope.$broadcast("LocalStorageModule.notification.error",i.message);return false}return true};var getFromCookies=function(e){if(!browserSupportsCookies()){$rootScope.$broadcast("LocalStorageModule.notification.error","COOKIES_NOT_SUPPORTED");return false}var t=document.cookie.split(",");for(var n=0;n<t.length;n++){var r=t[n];while(r.charAt(0)==" "){r=r.substring(1,r.length)}if(r.indexOf(prefix+e+"=")===0){return decodeURIComponent(r.substring(prefix.length+e.length+1,r.length))}}return null};var removeFromCookies=function(e){addToCookies(e,null)};var clearAllFromCookies=function(){var e=null,t=null;var n=prefix.length;var r=document.cookie.split(";");for(var i=0;i<r.length;i++){e=r[i];while(e.charAt(0)==" "){e=e.substring(1,e.length)}key=e.substring(n,e.indexOf("="));removeFromCookies(key)}};var stringifyJson=function(e,t){if(typeof e==="string"&&e.charAt(0)!=="{"&&!t){return e}if(e instanceof Object){var n="";if(e.constructor===Array){for(var r=0;r<e.length;n+=this.stringifyJson(e[r],true)+",",r++);return"["+n.substr(0,n.length-1)+"]"}if(e.toString!==Object.prototype.toString){return'"'+e.toString().replace(/"/g,"\\$&")+'"'}for(var i in e){n+='"'+i.replace(/"/g,"\\$&")+'":'+this.stringifyJson(e[i],true)+","}return"{"+n.substr(0,n.length-1)+"}"}return typeof e==="string"?'"'+e.replace(/"/g,"\\$&")+'"':String(e)};var parseJson=function(sJSON){if(sJSON.charAt(0)!=="{"){return sJSON}return eval("("+sJSON+")")};return{isSupported:browserSupportsLocalStorage,add:addToLocalStorage,get:getFromLocalStorage,remove:removeFromLocalStorage,clearAll:clearAllFromLocalStorage,stringifyJson:stringifyJson,parseJson:parseJson,cookie:{add:addToCookies,get:getFromCookies,remove:removeFromCookies,clearAll:clearAllFromCookies}}}])