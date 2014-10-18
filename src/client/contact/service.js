angular.module('globallinks.contact.service', [
  'ngResource'
]).service('ContactSvc', function($resource){
  Contact = $resource('/contact', null, {
    checkin: { method: 'POST', url: '/contact/checkin' },
    checkout: { method: 'POST', url: '/contact/checkout' }
  });

  Contact.currentUser = Contact.get();

  return Contact;
});
