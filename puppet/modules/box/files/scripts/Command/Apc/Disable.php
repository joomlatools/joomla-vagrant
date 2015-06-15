<?php
namespace Command\Apc;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class Disable extends Apc
{
    protected function configure()
    {
        $this->setName('apc:disable')
             ->setDescription('Disable APC');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $files = $this->_getConfigFiles($this->_ini_files);

        foreach($files as $file)
        {
            `sudo sed -i 's#^\(extension\|zend_extension\)=#; \\1=#' $file`;
        }

        exec('sudo service apache2 restart 2>&1 1> /dev/null');

        $output->writeln('APC has been disabled');
    }
}