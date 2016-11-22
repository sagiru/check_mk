// +------------------------------------------------------------------+
// |             ____ _               _        __  __ _  __           |
// |            / ___| |__   ___  ___| | __   |  \/  | |/ /           |
// |           | |   | '_ \ / _ \/ __| |/ /   | |\/| | ' /            |
// |           | |___| | | |  __/ (__|   <    | |  | | . \            |
// |            \____|_| |_|\___|\___|_|\_\___|_|  |_|_|\_\           |
// |                                                                  |
// | Copyright Mathias Kettner 2014             mk@mathias-kettner.de |
// +------------------------------------------------------------------+
//
// This file is part of Check_MK.
// The official homepage is at http://mathias-kettner.de/check_mk.
//
// check_mk is free software;  you can redistribute it and/or modify it
// under the  terms of the  GNU General Public License  as published by
// the Free Software Foundation in version 2.  check_mk is  distributed
// in the hope that it will be useful, but WITHOUT ANY WARRANTY;  with-
// out even the implied warranty of  MERCHANTABILITY  or  FITNESS FOR A
// PARTICULAR PURPOSE. See the  GNU General Public License for more de-
// tails. You should have  received  a copy of the  GNU  General Public
// License along with GNU Make; see the file  COPYING.  If  not,  write
// to the Free Software Foundation, Inc., 51 Franklin St,  Fifth Floor,
// Boston, MA 02110-1301 USA.

#include "ContactGroupsMemberColumn.h"
#include "ListColumn.h"

using std::make_unique;
using std::string;
using std::unique_ptr;

namespace {
class ContainsContact : public ListColumn::Contains {
public:
    explicit ContainsContact(contact *element) : _element(element) {}

    bool operator()(void *row) override {
        contactgroup *cg = static_cast<contactgroup *>(row);
        for (contactsmember *mem = cg->members; mem != nullptr;
             mem = mem->next) {
            if (mem->contact_ptr == _element) {
                return true;
            }
        }
        return false;
    }

private:
    contact *const _element;
};
}  // namespace

unique_ptr<ListColumn::Contains> ContactgroupsMemberColumn::makeContains(
    const string &name) {
    return make_unique<ContainsContact>(
        find_contact(const_cast<char *>(name.c_str())));
}

unique_ptr<ListColumn::Contains> ContactgroupsMemberColumn::containsContact(
    contact *ctc) {
    return make_unique<ContainsContact>(ctc);
}