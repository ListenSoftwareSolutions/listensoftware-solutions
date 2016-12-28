app.service('peopleService', function ($http) {
    this.get = function () {

        var accesstoken = sessionStorage.getItem('accessToken');

        var authHeaders = {};
        if (accesstoken) {
            authHeaders.Authorization = 'Bearer ' + accesstoken;
        }

        var response = $http({
            url: "/api/AddressBook",
            method: "GET",
            headers: authHeaders
        });
        return response;
    };
});

app.controller('PeopleController', function ($scope, peopleService) {
    $scope.People = [];

    $scope.Message = "";
    $scope.userName = sessionStorage.getItem('userName');


    loadPeople();

    function loadPeople() {


        var promise = peopleService.get();
        promise.then(function (resp) {
            $scope.People = resp.data;
            $scope.Message = "Call Completed Successfully";
        }, function (err) {
            $scope.Message = "Error!!! " + err.status
        });
    };
    $scope.logout = function () {

        sessionStorage.removeItem('accessToken');
        window.location.href = '/Login/SecurityInfo';
    };
});