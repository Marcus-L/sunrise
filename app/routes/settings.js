var express = require('express');
var fs = require('fs');
var path = require('path');
var cp = require('child_process');
var router = express.Router();

var settingspath = path.join(__dirname, '..', 'settings.txt');
var cronpath = path.join(__dirname, '..', 'cron.txt');

/* POST new settings. */
router.post('/', function(req, res, next) {
  // save settings
  fs.writeFileSync(settingspath, JSON.stringify(req.body));

  // configure cron
  var crondata = req.body.minute + ' ' + req.body.hour + ' * * * /home/pi/sunrise/scripts/do_sunrise\n';
  fs.writeFileSync(cronpath, req.body.enabled==true ? crondata : "\n");
  cp.exec('crontab -u pi ' + cronpath, function() {});
  res.send("OK");
});

/* GET settings */
router.get('/', function(req, res, next) {
  res.send(fs.readFileSync(settingspath));
});

module.exports = router;
