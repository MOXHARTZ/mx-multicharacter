MX = {};

$(function()
{
     window.addEventListener('message', function(event) 
     {
          switch (event.data.type) {
               case 'SetupCharacters':
                    BuildCharacters(event.data.handler, event.data.slots, event.data.useVIP);
               break;
               case 'notification':
                    Information(event.data.msg)
               break;
          }
     });
     
     $('.characters').mouseenter(function(){
          if ($(this).data('active') == true) {
               var information = $(this).data('inform')
               $(this).css({
                    'transform': 'scale(1.09)',
                    'transition': 'all .6s ease-in-out',
                    'box-shadow': '4px 4px 4px rgb(50, 0, 0)',
               });
               if (information.citizenid != null) {
                    $('#character-information').html(`
                    <div class="inform">First Name: <span data-inform="firstname">${information.firstname}</span></span>
                    <div class="line"></div>
                    <div class="inform">Last Name: <span data-inform="lastname">${information.lastname}</span></span>
                    <div class="line"></div>
                    <div class="inform">Gender: <span data-inform="sex">${(information.sex == 'm') && 'Male' || 'Female'}</span></span>
                    <div class="line"></div>
                    <div class="inform">Date Of Birth: <span data-inform="dateofbirth">${information.dateofbirth}</span></span>
                    <div class="line"></div>
                    <div class="inform">Cash: <span data-inform="cash">${information.cash}$</span></span>
                    <div class="line"></div>
                    <div class="inform">Bank: <span data-inform="bank">${information.bank}$</span></span>`);
               }else {
                    $('#character-information').html(`<div class="inform"><h1>Create A Character.</h1></div>`);
               }
               $('#information-container').fadeIn(300);
          }else {
               $(this).css({
                    'transform': 'scale(0.95)',
                    'transition': 'transform .6s ease-in-out, background-color .3s',
                    'box-shadow': '4px 4px 4px #010405',
                    'background-color': '#043666',
                    'color': 'rgba(255, 0, 0, 0.445)'
               });
               $('#character-information').html('<div class="inform"><h1>You must be a vip to create a character.</h1></div>');
               $('#information-container').fadeIn(300);
          }
     }).mouseleave(function(){
          $(this).removeAttr('style')
          $('#information-container').fadeOut(300);
     });

     $("#register").click(function(e) {
          e.preventDefault();
          var sex = 'male';
          var firstname = '';
          var lastname = '';
          var date = '';
          if ($('.container[data-sex="female"] input:checked').val() == 'on') {
               sex = 'female';
          }
          if ($('#firstname').val() != '' && $('#firstname').val() != null) {
              firstname = $('#firstname').val(); 
          }else {
               return Information('Firstname cannot be empty!');
          }
          if ($('#lastname').val() != '' && $('#lastname').val() != null) {
               lastname = $('#lastname').val(); 
          }else {
                return Information('Lastname cannot be empty!');
          }
          if ($('#date').val() != '' && $('#date').val() != null) {
               date = $('#date').val(); 
          }else {
                return Information('Date cannot be empty!');
          }
          $('#core').fadeOut(300);
          $.post('https://mx-multicharacter/CreateCharacter', JSON.stringify({
               firstname : firstname,
               lastname : lastname,
               sex : sex,
               date : date,
               queue : MX.CurrentCharacter
          }));
     });

     $('.fa-play').click(function(e) {
          e.preventDefault();
          $.post('https://mx-multicharacter/PlayCharacter', JSON.stringify({
               data: MX.CurrentCharacter
          }));
          $('#core').fadeOut(300);
     });

     $('.fa-user-minus').click(function(e) {
          e.preventDefault();
          AreYouSure("Do you approve the deletion of your character?", function(reply){
               if (reply == 'yes') {
                    $.post('https://mx-multicharacter/DeleteCharacter', JSON.stringify({
                         citizenid: MX.CurrentCharacter.citizenid
                    }));
               }
          })
     });

     $('.characters').click(function(e){
          e.preventDefault();
          var self = $(this)
          if (self.data('cid') == '' && self.data('active') == true) {
               $('#information-container').fadeOut(300);
               $('#characters-container').fadeOut(300);
               $('#properties-container').fadeOut(300);
               $('#register-container').animate({
                   top: '50%'
               }, 400);
               MX.Current = '#register-container';
               MX.CurrentCharacter = $(this).data('char');
          }else if (self.data('cid') != '' && self.data('active') == true) {
               var offset = $(this).offset();
               $('#properties-container').css({
                    'left': offset.left + 300
               });
               $('#properties-container').fadeIn(300);
               $('#information-container').fadeIn(300);
               MX.CurrentCharacter = self.data('cid');
               $.post('https://mx-multicharacter/SelectCharacter', JSON.stringify({
                    queue : self.data('char')
               }))
               
          }
     });
});

$(document).on('keydown', function() {
     if (event.keyCode == 27 && MX.Current != null) {
          if (MX.Current == '#register-container') {
               $(MX.Current).animate({
                   top: '-100%'
               }, 400);
               $('#information-container').fadeIn(400);
               $('#characters-container').fadeIn(400);

          }
          MX.Current = null;
     }
});

function BuildCharacters(data, slots, vip) {
     MX.Characters = data;
     MX.Slots = slots;
     if (vip) {
          if (Object.keys(MX.Slots).length != 0) {
               if (MX.Slots.slot2) {
                    $('.characters[data-char="2"]').data('active', true)
                    $('.characters[data-char="2"]').html('<i class="fas fa-plus fa-2x"></i>')
               }
               if (MX.Slots.slot3) {
                    $('.characters[data-char="3"]').data('active', true)
                    $('.characters[data-char="3"]').html('<i class="fas fa-plus fa-2x"></i>')
               }
               if (MX.Slots.slot4) {
                    $('.characters[data-char="4"]').data('active', true)
                    $('.characters[data-char="4"]').html('<i class="fas fa-plus fa-2x"></i>')
               }
          }
     }else {
          $('.characters[data-char="2"]').data('active', true);
          $('.characters[data-char="2"]').html('<i class="fas fa-plus fa-2x"></i>');
          $('.characters[data-char="3"]').data('active', true);
          $('.characters[data-char="3"]').html('<i class="fas fa-plus fa-2x"></i>');
          $('.characters[data-char="4"]').data('active', true);
          $('.characters[data-char="4"]').html('<i class="fas fa-plus fa-2x"></i>');
     }
     if (Object.keys(MX.Characters).length != 0) {
          $.each(MX.Characters, function(k,v) {
               if ($(`.characters[data-char="${v.queue}"]`).data('active')) {
                    $(`.characters[data-char="${v.queue}"]`).html(`<span id="character-name">${v.firstname + ' ' + v.lastname}</span>`);
                    $(`.characters[data-char="${v.queue}"]`).data('cid', v.citizenid);
                    $(`.characters[data-char="${v.queue}"]`).data('inform', MX.Characters[k]);
                    $(`.characters[data-char="${v.queue}"]`).data('active', true);
               }
          });
     }
     $('#core').fadeIn(400);
}

function AreYouSure(msg, cb) {
     $('#areyousure-container').html(`
     <span class="areyousure-msg">${msg}</span>
     <br>
     <div class="areyousure-yes-container">
         <span class="areyousure-yes">Yes</span>
     </div>
     <div class="areyousure-no-container">
         <span class="areyousure-no">No</span>
     </div>
     `);

     $('#areyousure-container').fadeIn(300);
     $('#areyousure-container').animate({
          top: '35%'
     });
     $('.areyousure-yes-container').click(function(e) {
          e.preventDefault();
          cb('yes');
          $('#areyousure-container').animate({
               top: '-100%'
          });
     });
     $('.areyousure-no-container').click(function(e) {
          e.preventDefault();
          cb('no');
          $('#areyousure-container').animate({
               top: '-100%'
          });
     });
}

function Information(msg) {
     $('#info-container').html(`<span class="inform-msg">${msg}</span>`)
     $('#info-container').fadeIn(300);
     $('#info-container').animate({
         right: '0'
     });
     setTimeout(() => {
         $('#info-container').animate({
             right: '-100%'
         }); 
     }, 4500);
}
