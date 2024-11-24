import express, { Request, Response } from 'express';
import { Logger } from '@nestjs/common';
import { ShellService } from './shell.service';
import { Commands } from './enums/commands';
import { json } from 'stream/consumers';

const cors = require('cors')


/**
 * @global variables
 */
const app = express();
const port = 3000;
const logger = new Logger();
const shell = new ShellService(logger);

/**
 * @default middlewares
 */
app.use(express.json());
app.use(cors())



/**
 * HTTP routes
 */

app.put('/redis/nodes', async (req, res) => {
    const nodes = req.query.nodes;
    await shell.updateNodes('redis', nodes as string)
    res.send(`Redis now has ${nodes} containers running`);
});

app.put('/mongo/nodes', async (req, res) => {
    const nodes = req.query.nodes;
    await shell.updateNodes('mongo', nodes as string)
    res.send(`Mongo now has ${nodes} containers running`);
});

app.get('/docker', async (req, res) => {
    const stdout = await shell.showDocker();
    res.send(stdout);
});


app.get('/Hello', (req, res) => {
  res.send('Hello, from  Express!');
});





// here we start
app.listen(port, async () => {
  logger.log(`Server has started on port ${port}`);
  await shell.listDir();


});
