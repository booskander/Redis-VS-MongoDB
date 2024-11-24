import { Commands } from "./enums/commands";
const { exec } = require('child_process');
const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

export class ShellService {
    logger: any;

    constructor(logger: any) {
        this.logger = logger;
    }


    async updateNodes(db: string, num: string) {
        return this.execute(`
            ls && 
            cd ../terraform && 
            ls &&
            echo "yes" | terraform apply -var="${db}_replicas_count=${num}"
        `);
    }

    async pingRedis() {
        return this.execute(``)
    }

    async showDocker() {
        return this.execute('docker ps');
    }

    async listDir() {
        return this.execute('ls');
    }

    private execute(command: string): Promise<string> {
        return new Promise<string>((resolve, reject) => {
            exec(command,
                 (error: any, stdout: string, stderr: string) => {
                if (error) {
                    this.logger.error(`Error executing command: ${error.message}`);
                    reject(error);
                } else if (stderr) {
                    this.logger.error(`stderr: ${stderr}`);
                    reject(stderr);
                } else {
                    this.logger.log(`stdout: ${stdout}`);
                    resolve(stdout);  
                }
            });
        });
    }
}
