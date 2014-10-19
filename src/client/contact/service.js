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
  })

  return Contact;
})
;
