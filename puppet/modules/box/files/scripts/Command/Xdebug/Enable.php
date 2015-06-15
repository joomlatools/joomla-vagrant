<?php
namespace Command\Xdebug;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class Enable extends Xdebug
{
    protected function configure()
    {
        $this->setName('xdebug:enable')
             ->setDescription('Enable Xdebug');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $files = $this->_getConfigFiles($this->_ini_files);

        foreach($files as $file) {
            `sudo sed -i 's#^; zend_extension=#zend_extension=#' $file`;
        }

        `sudo service apache2 restart 2>&1 1> /dev/null`;

        $output->writeln('Xdebug has been enabled');
    }
}