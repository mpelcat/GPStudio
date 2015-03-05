#include "node.h"

#include <QFile>
#include <QFileInfo>
#include <QDebug>

Node::Node()
{
    _valid = false;
}

Node::~Node()
{
    for(int i=0; i<_blocks.size(); i++) delete _blocks[i];
}

QString Node::name() const
{
    return _name;
}

void Node::setName(const QString &name)
{
    _name = name;
}

bool Node::isValid() const
{
    return _valid;
}

QList<Block *> &Node::blocks()
{
    return _blocks;
}

const QList<Block *> &Node::blocks() const
{
    return _blocks;
}

void Node::addBlock(Block *block)
{
    _blocks.append(block);
}

Node *Node::readFromFile(const QString &fileName)
{
    QDomDocument doc;
    QFile file(fileName);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) qDebug()<<"Cannot open"<<file.fileName();
    else
    {
        if(!doc.setContent(&file)) qDebug()<<"Cannot open"<<file.fileName();
        else
        {
            return Node::fromNodeGenerated(doc.documentElement());
        }
        file.close();
    }
    return NULL;
}

Node *Node::fromNodeGenerated(const QDomElement &domElement)
{
    Node *node=new Node();
    node->setName(domElement.attribute("name","no_name"));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="blocks") node->_blocks.append(Block::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    node->_valid=true;
    return node;
}
