#!/usr/bin/python

# WARNING: python2.7 required.
# In Windows, run this file with admin privileges.
# (i.e. Run cmd.exe as Administrator then run 'python setup.py' in cmd)
# Otherwise it will fail to create symlinks.

# The idea comes from
# http://dotfiles.github.io/
# https://github.com/benmccormick/dotfiles


# --- USAGE ---
# python setup.py [<config-name1> <config-name2> ...]
# e.g. python setup.py vimconfig cmderconfig
# If no cofig-name supplied, configures all configs available.

import os
import sys
import shutil
import re
import subprocess

home_dir = os.path.expanduser('~')
dotfiles_dir = os.path.join(home_dir, '.dotfiles')
backup_dir = os.path.join(home_dir, '.dotfiles-backup')


def git(*args):
    """ Utility function for git commands.
    """
    return subprocess.check_output(['git'] + list(args))


# http://stackoverflow.com/questions/6260149/os-symlink-support-in-windows
# I don't want to use sitecostomize.py as the above link mentions.
def symlink(source, link_name):
    """ Create symbolic link 'link_name' pointing 'source'.

    If the os module has no symlink functionality in python,
    it is probably running on windows, try kernel32.dll to create symlinks.

    This function requires admin privileges on Windows.
    """

    os_symlink = getattr(os, "symlink", None)
    if callable(os_symlink):
        os_symlink(source, link_name)
    else:
        import ctypes
        csl = ctypes.windll.kernel32.CreateSymbolicLinkW
        csl.argtypes = (ctypes.c_wchar_p, ctypes.c_wchar_p, ctypes.c_uint32)
        csl.restype = ctypes.c_ubyte
        flags = 1 if os.path.isdir(source) else 0
        if csl(link_name, source, flags) == 0:
            raise ctypes.WinError()


def do_symlinks(srcdir, dstdir, predot):
    """ Creates a symbolic link for each entry in srcdir ending with .symlink
    in dstdir directory, prepending them with a '.' if predot is True.

    If some dot entries already exist in dstdir, moves them to backup
    directory. If backup directory has the entries with the same name, raises
    an error. User must clear out previously backed up entries manually.
    """

    for root, subdirs, filenames in os.walk(srcdir):
        entries = filenames
        entries.extend(subdirs)
        for entry in entries:
            if not re.match('.*\.symlink$', entry):
                # Don't symlink this, it doesn't end with .symlink
                continue

            # ------------------------------
            # This entry is to be symlinked.
            # ------------------------------

            # Get rid of .symlink extension
            sym_entry = entry[:-len('.symlink')]
            if predot:
                # Prepend with a dot
                sym_entry = '.' + sym_entry

            # Convert sym_entry to its absolute path
            sym_entry = os.path.abspath(os.path.join(dstdir, sym_entry))

            # Get absolute path of the source
            source = os.path.abspath(os.path.join(root, entry))

            if not os.path.exists(sym_entry):
                # Entry does not exist in home directory, ready for symlink
                symlink(source, sym_entry)
                print 'Linked %s to %s' % (sym_entry, source)
            else:
                # Entry exists in home directory, back up, then symlink
                print 'Backing up %s' % (sym_entry)
                shutil.move(sym_entry, backup_dir)
                symlink(source, sym_entry)
                print 'Linked %s to %s' % (sym_entry, source)


def download_vundle():
    """ Get vundle
    If vundle path exists, pull vundle from git repo.
    """

    vundle_dir = os.path.join(home_dir, '.vim', 'bundle', 'Vundle.vim')
    if not os.path.exists(vundle_dir):
        git('clone', 'https://github.com/gmarik/Vundle.vim.git', vundle_dir)
    else:
        os.chdir(vundle_dir)
        git('pull')
        os.chdir(home_dir)


def download_spacemacs():
    """ Get spacemacs
    If emacs.d.symlink path exists, pull spacemacs from git repo.
    """

    spacemacs_dir = os.path.join(dotfiles_dir, 'spacemacsconfig', 'public', 'emacs.d.symlink')
    if not os.path.exists(spacemacs_dir):
        git('clone', '--recursive', 'https://github.com/syl20bnr/spacemacs.git', spacemacs_dir)
    else:
        os.chdir(spacemacs_dir)
        git('pull')
        os.chdir(home_dir)


# dotfiles
#   vimconfig
#       vim.symlink (dir)
#       vimrc.symlink
def vimconfig_symlink():
    vimconfig_dir = os.path.join(dotfiles_dir, 'vimconfig')
    do_symlinks(vimconfig_dir, home_dir, True)
    download_vundle()
    print 'Now, start your vim and run :PluginInstall! and :PluginClean'


# dotfiles
#   gitconfig
#      gitconfig.symlink
def gitconfig_symlink():
    gitconfig_dir = os.path.join(dotfiles_dir, 'gitconfig')
    do_symlinks(gitconfig_dir, home_dir, True)


# dotfiles
#   cmderconfig
#       vendor
#           init.bat.symlink
#       config
#           ConEmu.xml.symlink
def cmderconfig_symlink():
    if not sys.platform.startswith('win'):
        print 'cmder will NOT be symlinked, this is not a windows system!'
        return

    cmderconfig_dir = os.path.join(dotfiles_dir, 'cmderconfig')
    cmder_dir = os.path.join(home_dir, 'cmder')
    if os.path.exists(cmder_dir):
        vendor_dir = os.path.join(cmder_dir, 'vendor')
        if os.path.exists(vendor_dir):
            conf_vendor_dir = os.path.join(cmderconfig_dir, 'vendor')
            do_symlinks(conf_vendor_dir, vendor_dir, False)
        else:
            print '%s does not exists!' % (vendor_dir)

        config_dir = os.path.join(cmder_dir, 'config')
        if os.path.exists(config_dir):
            conf_config_dir = os.path.join(cmderconfig_dir, 'config')
            do_symlinks(conf_config_dir, config_dir, False)
        else:
            print '%s does not exists!' % (config_dir)
    else:
        print '%s does not exists!' % (cmder_dir)
        print 'Get cmder and put it in %s and name it "cmder"' % (home_dir)



# dotfiles
#   spacemacsconfig
#       public
#           emacs.d.symlink (dir created after download)
#           spacemacs.symlink
#       private
#           layers
#              layer1.symlink (dir)
#              layer2.symlink (dir) ...
#           snippets
#              x-mode.symlink
#              y-mode.symlink ...
def spacemacsconfig_symlink():
    download_spacemacs()
    conf_public_dir = os.path.join(dotfiles_dir, 'spacemacsconfig', 'public')
    do_symlinks(conf_public_dir, home_dir, True)

    layers_dir = os.path.join(home_dir, '.emacs.d', 'private')
    conf_layers_dir = os.path.join(dotfiles_dir, 'spacemacsconfig', 'private', 'layers')
    do_symlinks(conf_layers_dir, layers_dir, False)
    
    snippets_dir = os.path.join(home_dir, '.emacs.d', 'private', 'snippets')
    conf_snippets_dir = os.path.join(dotfiles_dir, 'spacemacsconfig', 'private', 'snippets')
    do_symlinks(conf_snippets_dir, snippets_dir, False)


def main():
    # Tuple of all configs ready to be symlinked.
    configs = ('vimconfig', 'gitconfig', 'cmderconfig', 'spacemacsconfig',)

    if not os.path.exists(backup_dir):
        # Create a backup folder.
        os.mkdir(backup_dir)
        print '%s created.' % (backup_dir)
    else:
        print '%s already exists.' % (backup_dir)

    if len(sys.argv) == 1:
        # Symlink all configs
        for config in configs:
            print 'Symlinking %s' % (config)
            globals()[config + '_symlink']()
    else:
        # Symlink the configs given by arguments
        for config in sys.argv[1:]:
            if config in configs:
                print 'Symlinking %s' % (config)
                globals()[config + '_symlink']()
            else:
                print '%s is not a valid configuration option.' % (config)
                print 'Options are:'
                print configs


if __name__ == "__main__":
    main()
