var myApp = angular.module('ClockApp', []);
var promise;

myApp.controller('ClockController', function ($scope,$interval) {
    $scope.tickInterval = 1000;
    var iStopWatchSeconds = 1;
    var tick=function(){
        $scope.clock = Date.now();
    }
    tick();
    $interval(tick, $scope.tickInterval);

    var stopWatch = function () {
        $scope.stopWatchDisplay = iStopWatchSeconds;
        iStopWatchSeconds++;
    }
    $scope.startTimer = function () {
        promise=$interval(stopWatch, 1000);
    }

    $scope.stopTimer = function () {
        if(angular.isDefined(stopWatch)){
        $interval.cancel(promise);
        }
    }
    $scope.resetTimer = function () {
        $scope.stopTimer();
        iStopWatchSeconds=1
        $scope.stopWatchDisplay = '';

    }

});