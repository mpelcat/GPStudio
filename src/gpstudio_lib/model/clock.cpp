#include "clock.h"

#include "block.h"

Clock::Clock(Block *parent)
    : _parent(parent)
{
}

Clock::~Clock()
{
}

QString Clock::name() const
{
    return _name;
}

void Clock::setName(const QString &name)
{
    _name = name;
}

QString Clock::group() const
{
    return _group;
}

void Clock::setGroup(const QString &group)
{
    _group = group;
}

qint16 Clock::shift() const
{
    return _shift;
}

void Clock::setShift(const qint16 &shift)
{
    _shift = shift;
}

qint32 Clock::min() const
{
    return _min;
}

void Clock::setMin(const qint32 &min)
{
    _min = min;
}

qint32 Clock::max() const
{
    return _max;
}

void Clock::setMax(const qint32 &max)
{
    _max = max;
}

qint32 Clock::typical() const
{
    return _typical;
}

void Clock::setTypical(const qint32 &typical)
{
    _typical = typical;
}

QString Clock::description() const
{
    return _description;
}

void Clock::setDescription(const QString &desc)
{
    _description = desc;
}

Block *Clock::parent() const
{
    return _parent;
}

void Clock::setParent(Block *parent)
{
    _parent = parent;
}

Clock *Clock::fromNodeGenerated(const QDomElement &domElement)
{
    Clock *clock=new Clock();
    bool ok=false;

    clock->setName(domElement.attribute("name","no_name"));
    clock->setGroup(domElement.attribute("group",""));

    int shift = domElement.attribute("shift","0").toInt(&ok);
    if(ok) clock->setShift(shift); else clock->setShift(0);

    int min = domElement.attribute("min","0").toInt(&ok);
    if(ok) clock->setMin(min); else clock->setMin(0);

    int max = domElement.attribute("max","0").toInt(&ok);
    if(ok) clock->setMax(max); else clock->setMax(0);

    int typical = domElement.attribute("typical","0").toInt(&ok);
    if(ok) clock->setTypical(typical); else clock->setTypical(0);

    clock->setDescription(domElement.attribute("desc",""));

    return clock;
}
