'use strict'

module.exports = ($scope, $rootScope, $state, $timeout, $mdToast, Auth, Graphics) ->

    $scope.tweets = []
    $scope.user = {}
    $scope.users = []

    $scope.cameraOpen = false

    if !Graphics.alreadyInit()
        Graphics.init()


    #see if user is logged in. If not, redirect to login
    if !Auth.isLoggedIn()
        $state.go 'login'


    $scope.flyby =
        on: false


    #Toast Setup
    $scope.toastPosition =
        bottom: true
        top: false
        left: true
        right: false


    $scope.getToastPosition = ->
        return Object.keys $scope.toastPosition
            .filter((pos) ->
                return $scope.toastPosition[pos]
                ).join ' '

    $scope.showToast = (content) ->
        $mdToast.show($mdToast.simple()
            .content(content)
            .position($scope.getToastPosition())
            .hideDelay(3000)
            )




    #WELCOME USER
    $scope.user = Auth.getUser()
    $scope.users.push($scope.user)

    #if user has already been, append 'back'
    if $scope.user.hasOwnProperty('extraMsg')

        $scope.message = "Welcome #{$scope.user.extraMsg} #{$scope.user.name}"
        $scope.showToast("Welcome #{$scope.user.extraMsg} #{$scope.user.name}")


        $scope.name = $scope.user.name
        $scope.flyby.on = true
        $scope.flyby.text = "Welcome #{$scope.user.extraMsg} To The Party #{$scope.user.name}"

        $timeout(->
            $scope.flyby.on = false
            $scope.flyby.text = ''
            )
    else
        $scope.message = "Welcome #{$scope.user.name}"
        $scope.showToast("Welcome #{scope.user.name}")


        $scope.name = $scope.user.name
        $scope.flyby.on = true

        $scope.flyby.text = "Welomce To The Party #{$scope.user.name}"

        $timeout( ->
            $scope.flyby.on = false
            $scope.flyby.text = ''
            )


    $scope.openCamera = ->
        $scope.cameraOpen = true

    $scope.togglePeople = ->
        $scope.people.open = !$scope.people.open
        console.log $scope.people

    $scope.toggleSettings = ->
        $scope.settings.open = !$scope.settings.open

    $scope.flip = ->
        Graphics.flip()



    #LISTEN FOR UPLOADS
    $rootScope.$on 'msg', (event, data) ->
        console.log data
        $scope.flyby.on = true
        $scope.flyby.text = data

        $scope.showToast(data)

        $timeout( ->
            $scope.flyby.on = false
            $scope.flyby.text = ''
            )


