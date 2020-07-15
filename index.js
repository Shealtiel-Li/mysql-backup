const schedule = require('node-schedule');
const {exec} = require('child_process');
const config = require('config')
const path = require('path')
const moment = require('moment')

process.env.BACKUP_DIR = path.resolve(__dirname, 'backup');
process.env.USER = config.get('mysql.user');
process.env.PASSWORD = config.get('mysql.password');
process.env.CONTAINER_NAME = config.get('mysql.containerName');
process.env.DIR = config.get('mysql.dir');
process.env.DUMP_PATH = config.get('mysql.dumpDir');
process.env.ADMIN_PATH = path.join(config.get('mysql.adminDir'));
process.env.BINLOG_FILE = path.join(process.env.DIR, 'binlog.index');
process.env.DATABASE = config.get('mysql.database');
if (process.env.DATABASE === '-A') {
    process.env.RESET_MASTRE = true;
}


function executeShell(file, ...args) {
    return new Promise((resolve, reject) => {
        exec(`sh ${file} ${args.join(' ')}`, (err, stdout, stderr) => {
            if (err) {
                reject(err);
                return;
            }
            if (stdout) {
                console.log(`stdout: ${stdout}`);
            }
            if (stderr) {
                console.log(`stderr: ${stderr}`);
            }
            resolve();
        });
    })
}

function getFolder(str) {
    return path.join(process.env.BACKUP_DIR, str, moment().format('YYYYMMDD'));
}

function fullyBak() {
    return executeShell('core/mysql-fully.sh', [getFolder('week')]);
}

function dailyBak() {
    return executeShell('core/mysql-daily.sh', [getFolder('day')]);
}

fullyBak().then(dailyBak);

schedule.scheduleJob('0 45 23  *  *  0', fullyBak)

schedule.scheduleJob('0 30 23  *  *  *', dailyBak)
