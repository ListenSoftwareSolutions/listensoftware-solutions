app.service('peopleService', function ($http) {
    this.post = function (addressBook) {
        var accesstoken = sessionStorage.getItem('accessToken');

        var authHeaders = {};
        if (accesstoken) {
            authHeaders.Authorization = 'Bearer ' + accesstoken;
        }
        var response = $http({
            url: "/api/AddressBook",
            method: "POST",
            data: addressBook,
            headers: authHeaders
        });
        return response;
    };
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
    this.getPerson = function (addressId) {

        var accesstoken = sessionStorage.getItem('accessToken');

        var authHeaders = {};
        if (accesstoken) {
            authHeaders.Authorization = 'Bearer ' + accesstoken;
        }

        var response = $http({
            url: "/api/AddressBook/"+addressId,
            method: "GET",
            headers: authHeaders
        });
        return response;
    };
});
/*
app.controller('PeopleEditController', ['$scope','peopleService', function ($scope, peopleService) {
    $scope.People = [];
    
    
}]);
*/
app.controller('PeopleController', ['$scope','peopleService', function ($scope, peopleService) {
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

    $scope.editPerson = function (addressId) {
        window.location("/people/edit/" + addressId);
        /*var promise = peopleService.getPerson(addressId);
        promise.then(function (person) {
            $scope.addressBook = person.data[0];
            $scope.AddressId = person.data[0].AddressId;
            $scope.Name = person.data[0].Name;
            $scope.FirstName = person.data[0].FirstName;
            $scope.LastName = person.data[0].LastName;
            
            $scope.Message = "Call Completed Successfully";
        }, function (err) {
            $scope.Message = "Error!!! " + err.status
        });
        */
    }

    $scope.addPerson = function () {
        var promise=peopleService.post($scope.addressBook);
        promise.then(function (resp) {
            $scope.Message = "Call Completed Successfully";
            //window.location.path("/people");
        }, function (err) {
            $scope.Message = "Error!!! " + err.status
        });
    }
    $scope.logout = function () {

        sessionStorage.removeItem('accessToken');
        window.location.href = '/Login/SecurityInfo';
    };
}]);