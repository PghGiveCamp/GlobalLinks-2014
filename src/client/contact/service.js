angular.module('globallinks.contact.service', [
  'ngResource'
]).service('ContactSvc', function($resource){
  Contact = $resource('/contact', null, {
    checkin: { method: 'POST', url: '/contact/checkin' },
    checkout: { method: 'POST', url: '/contact/checkout' }
  });

  var u = Contact.currentUser = Contact.get();

  Object.defineProperty(Contact.currentUser, 'name', {
    get: function(){
      return (u.first_name || '') + ' ' + (u.last_name || '');
    }
  });

  Object.defineProperty(Contact.currentUser, 'status', (function(){
    var _status = '';
    return {
      set: function(_){ _status = _; },
      get: function(){
        if(_status.length > 0){
          return _status;
        }
        if(Contact.currentUser.checked_in){
          return 'started';
        }
        return '';
      }
    }
  }()));

  return Contact;
})
;
