MX = new Object;
$(function () {
     window.addEventListener('message', function (event) {
          switch (event.data.type) {
               case 'SetupCharacters':
                    BuildCharacters(event.data.handler, event.data.slots, event.data.useVIP);
                    break;
               case 'notification':
                    Information(event.data.msg)
                    break;
               case 'refresh':
                    Refresh()
                    break;
          }
     });

     $("#register").click(function (e) {
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
          } else {
               return Information('Firstname can\'t be empty!');
          }
          if ($('#lastname').val() != '' && $('#lastname').val() != null) {
               lastname = $('#lastname').val();
          } else {
               return Information('Lastname can\'t be empty!');
          }
          if ($('#date').val() != '' && $('#date').val() != null) {
               date = $('#date').val();
          } else {
               return Information('Date can\'t be empty!');
          }
          $('#core').fadeOut(300);
          $.post('https://mx-multicharacter/CreateCharacter', JSON.stringify({
               firstname: firstname,
               lastname: lastname,
               sex: sex,
               date: date,
               queue: MX.CurrentCharacter
          }));
     });

     $('#play').click(function (e) {
          e.preventDefault();
          $.post('https://mx-multicharacter/PlayCharacter', JSON.stringify({
               data: MX.CurrentCharacter
          }));
          $('#core').fadeOut(300);
     });

     $('#delete').click(function (e) {
          e.preventDefault();
          AreYouSure("Do you approve the deletion of your character?", function (reply) {
               if (reply == 'yes') {
                    $.post('https://mx-multicharacter/DeleteCharacter', JSON.stringify({
                         citizenid: MX.CurrentCharacter
                    }));
               }
          })
     });
});

$(document).on('keydown', function () {
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
     document.getElementById('characters-container').innerHTML = `
          <div class="characters" data-char="1" data-cid="" data-active="true" data-inform={}>
                         <i class="fas fa-plus fa-2x"></i>
                    </div>
                    <div class="characters" data-char="2" data-cid="" data-active="false" data-inform={}> 
                         <i class="fas fa-times fa-2x"></i>
                    </div>
                    <div class="characters" data-char="3" data-cid="" data-active="false" data-inform={}>
                         <i class="fas fa-times fa-2x"></i>
                    </div>
                    <div class="characters" data-char="4" data-cid="" data-active="false" data-inform={}>
                         <i class="fas fa-times fa-2x"></i>
          </div>`;

     $('.characters').click(function (e) {
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
          } else if (self.data('cid') != '' && self.data('active') == true) {
               if (MX.Current) {
                    $(MX.Current).html(`<span id="character-name">${MX.CurrentData.firstname + ' ' + MX.CurrentData.lastname}</span>`)
                    $(MX.Current).removeAttr('style')
                    MX.Current = false
                    MX.CurrentData = {}
               }
               var offset = $(this).offset();
               var information = $(this).data('inform')
               $('#properties-container').css({
                    'left': offset.left + 115
               });
               MX.Current = $(this);
               MX.CurrentData = information
               $(this).html(`<div id="information-container"><div id="character-information"><div id="name">     <div id="name-header">Los Santos</div>     <div id="name-inf">${information.firstname} ${information.lastname}</div></div><div id="dob">     <div id="dob-header">Date Of Birth</div>     <div id="dob-inf">${information.dateofbirth}</div></div><div id="phone">     <div id="phone-header">Phone Number</div>     <div id="phone-inf">${information.phone_number}</div></div><div id="job">     <div id="job-header">Job Name</div>     <div id="job-inf">${information.job}</div></div><div id="gender">     <div id="gender-header">Gender</div>     <div id="gender-inf">${information.sex}</div></div><div id="cash">     <div id="cash-header">Cash</div>     <div id="cash-inf">${information.cash}$</div></div><div id="bank"><div id="bank-header">Bank</div><div id="bank-inf">${information.bank}$</div></div></div></div>`)
               $('#properties-container').fadeIn(300);
               $('#information-container').fadeIn(300);
               MX.CurrentCharacter = self.data('char');
               $.post('https://mx-multicharacter/SelectCharacter', JSON.stringify({
                    queue: self.data('char')
               }))
               $(this).css({
                    'transform': 'scale(1.09)',
                    'transition': 'all .6s ease-in-out',
                    'transition': 'all .6s ease-in-out',
                    'box-shadow': '4px 4px 4px rgba(0, 0, 0, 0.6)',
                    'top': '15px',
                    'height': '200%',
                    'width': '17%',
               });
          } else if (self.data('active') == false) {
               Information('You can\'t use this slot.')
          }
     });
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
     } else {
          $('.characters[data-char="2"]').data('active', true);
          $('.characters[data-char="2"]').html('<i class="fas fa-plus fa-2x"></i>');
          $('.characters[data-char="3"]').data('active', true);
          $('.characters[data-char="3"]').html('<i class="fas fa-plus fa-2x"></i>');
          $('.characters[data-char="4"]').data('active', true);
          $('.characters[data-char="4"]').html('<i class="fas fa-plus fa-2x"></i>');
     }
     if (Object.keys(MX.Characters).length != 0) {
          $.each(MX.Characters, function (k, v) {
               var queue = v.citizenid.charAt(4);
               if ($(`.characters[data-char="${queue}"]`).data('active')) {
                    $(`.characters[data-char="${queue}"]`).html(`<span id="character-name">${v.firstname + ' ' + v.lastname}</span>`);
                    $(`.characters[data-char="${queue}"]`).data('cid', v.citizenid);
                    $(`.characters[data-char="${queue}"]`).data('inform', MX.Characters[k]);
                    $(`.characters[data-char="${queue}"]`).data('active', true);
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
     $('.areyousure-yes-container').click(function (e) {
          e.preventDefault();
          cb('yes');
          $('#areyousure-container').animate({
               top: '-100%'
          });
     });
     $('.areyousure-no-container').click(function (e) {
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

function Refresh() {
     $('#core').fadeOut(0);
     if (MX.Current) {
          $(MX.Current).html(`<span id="character-name">${MX.CurrentData.firstname + ' ' + MX.CurrentData.lastname}</span>`)
          $(MX.Current).removeAttr('style')
          MX.Current = false
          MX.CurrentData = {}
     }
     $('#properties-container').fadeOut(300);
     MX.Current = null;
     MX.CurrentCharacter = null;
}