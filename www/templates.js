angular.module('contact.template', [])
.run(function($templateCache){
    $templateCache.put('contact', '<div class="Contact"><h2>Contact Details</h2></div>');
});
angular.module('login.template', [])
.run(function($templateCache){
    $templateCache.put('login', '<div id="login" class="container-fluid"><div class="row"><form role="form"><div class="form-group"><input type="text" for="username" placeholder="Username or Email" id="username" class="form-control"/></div><div class="form-group"><input type="password" for="username" placeholder="Username or Email" id="password" class="form-control"/></div></form></div></div>');
});