---
title: AngularJS-ngResource-save
date: 2016-07-06 14:43:02
category: AngularJS
tags: [Coursera, JavaScript, AngularJS, ngResource]
---

Coursera AngularJS 课程的最后一个任务，添加提交 feedback 到 server 的功能   
之前已经实现了添加 feedback 并保存在 client 的功能   
现在只需要利用`$resource`的`$save`方法将 feedback 的 json 对象`post`到 server   

本以为照葫芦画瓢很简单，结果总是会报错如下
>TypeError: feedbackFactory.getFeedbacks(...).$save is not a function

仔细对照[官方文档](https://docs.angularjs.org/api/ngResource/service/$resource)找到原因：

>The action methods on the class object or instance object can be invoked with the following parameters:
>
> - HTTP GET "class" actions: Resource.action([parameters], [success], [error])
> - non-GET "class" actions: Resource.action([parameters], postData, [success], [error])
> - non-GET instance actions: instance.$action([parameters], [success], [error])

问题出在我试图使用`non-GET "class" actions`，却加了`$`符号且没有带上`postData`   

所以解决方式有两种

# non-GET "class" actions

```js services.js
...
        .constant("baseURL", "http://localhost:3000/")
        .service('feedbackFactory', ['$resource', 'baseURL', function($resource,baseURL) { 

            this.getFeedbacks = function(){
                return $resource(baseURL+"feedback",null);
            };

        }])
...
```

```js controllers.js
...
        .controller('FeedbackController', ['$scope', 'feedbackFactory', function($scope, feedbackFactory) {

            $scope.feedbacks = feedbackFactory.getFeedbacks().query(
                function(response){
                    $scope.feedbacks = response;
                    console.log($scope.feedbacks);
                }
            );

            $scope.sendFeedback = function() {

                console.log($scope.feedbacks);

                $scope.feedbacks.push($scope.feedback);
                feedbackFactory.getFeedbacks().save($scope.feedback);

                if ($scope.feedback.agree && ($scope.feedback.mychannel == "")) {
                    $scope.invalidChannelSelection = true;
                    console.log('incorrect');
                }
                else {
                    $scope.invalidChannelSelection = false;
                    $scope.feedback = {mychannel:"", firstName:"", lastName:"", agree:false, email:"" };
                    $scope.feedbackForm.$setPristine();
                    console.log($scope.feedback);
                }
            };
        }])
...
```

# non-GET instance actions

```js service.js
...
        .constant("baseURL", "http://localhost:3000/")
        .service('feedbackFactory', ['$resource', 'baseURL', function($resource,baseURL) { 

                return $resource(baseURL+"feedback/:id",null);

        }])
...
```

```js controllers.js
...
        .controller('FeedbackController', ['$scope', 'feedbackFactory', function($scope, feedbackFactory) {

            // $scope.feedbacks = feedbackFactory.getFeedbacks().query(
            //     function(response){
            //         $scope.feedbacks = response;
            //         console.log($scope.feedbacks);
            //     }
            // );

            $scope.sendFeedback = function() {

                var newFeedback = new feedbackFactory($scope.feedback);
                newFeedback.$save();

                // $scope.feedbacks.push($scope.feedback);
                // feedbackFactory.getFeedbacks().save($scope.feedback);

                if ($scope.feedback.agree && ($scope.feedback.mychannel == "")) {
                    $scope.invalidChannelSelection = true;
                    console.log('incorrect');
                }
                else {
                    $scope.invalidChannelSelection = false;
                    $scope.feedback = {mychannel:"", firstName:"", lastName:"", agree:false, email:"" };
                    $scope.feedbackForm.$setPristine();
                    console.log($scope.feedback);
                }
            };
        }])
...
```

由于第二种方式没有加上`[success], [error]`处理，看起来要简单许多   
[Stackoverflow](http://stackoverflow.com/questions/36558499/angularjs-post-changes-to-the-server-using-resource/36564415#36564415) 里一位疑似该课程的同学用的就是这种方式   
不过相对来说第一种方式跟其他部分代码风格更统一   


大致如此.